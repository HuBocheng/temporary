`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/26 11:20:16
// Design Name: 
// Module Name: fetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define STARTADDR 32'd0
module fetch(
  input clk, // 时钟
  input resetn, // 复位信号，低电平有效
  
  input IF_valid, // 取指级有效信号
  input next_fetch,// 取下一条指令，用来锁存PC 值
  input [31:0] inst, // inst_rom 取出的指令
  input [32:0] jbr_bus, // 跳转总线
  
  output [31:0] inst_addr, // 发往inst_rom 的取指地址
  output reg IF_over, // IF 模块执行完成
  output [63:0] IF_ID_bus, // IF->ID 总线
 
  //展示PC 和取出的指令
  output [31:0] IF_pc,
  output [31:0] IF_inst
    );
    //-----{程序计数器PC}begin
      wire [31:0] next_pc;//实际的下一步pc，可能跳转可能顺序
      wire [31:0] seq_pc;//按顺序向下应取的pc
      reg [31:0] pc;//当前的pc
      //跳转pc
      wire jbr_taken;
      wire [31:0] jbr_target;
      assign {jbr_taken, jbr_target} = jbr_bus; //跳转总线
     
      assign seq_pc[31:2] = pc[31:2] + 1'b1; //下一指令地址：PC=PC+4
      assign seq_pc[1 :0] = pc[1:0];
     
      // 新指令：若指令跳转，为跳转地址；否则为下一指令
      assign next_pc = jbr_taken ? jbr_target : seq_pc;
     
      always @(posedge clk) // PC 程序计数器
      begin
        if (!resetn)
        begin
            pc <= `STARTADDR; // 复位，取程序起始地址
        end
        else if (next_fetch)
        begin
            pc <= next_pc; // 不复位，取新指令
        end
      end
      //-----{程序计数器PC}end
     
      //-----{发往inst_rom 的取指地址}begin
      assign inst_addr = pc;
      //-----{发往inst_rom 的取指地址}end
     
      //-----{IF 执行完成}begin
    
      //由于指令rom 为同步读写的,
      //取数据时，有一拍延时
      //即发地址的下一拍时钟才能得到对应的指令
      //故取指模块需要两拍时间
      //将IF_valid 锁存一拍即是IF_over 信号
      always @(posedge clk)
      begin
        IF_over <= IF_valid;
      end
      //如果指令rom 为异步读的，则IF_valid 即是IF_over 信号，
      //即取指一拍完成
      //-----{IF 执行完成}end
     
      //-----{IF->ID 总线}begin
      assign IF_ID_bus = {pc, inst};
      //-----{IF->ID 总线}end
     
      //-----{展示IF 模块的PC 值和指令}begin
      assign IF_pc = pc;
      assign IF_inst = inst;
      //-----{展示IF 模块的PC 值和指令}end
endmodule
