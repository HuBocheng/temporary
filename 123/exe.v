`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/26 11:30:58
// Design Name: 
// Module Name: exe
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


module exe( // 执行级
 input EXE_valid, // 执行级有效信号

 input [149:0] ID_EXE_bus_r,// ID->EXE 总线
 output EXE_over, // EXE 模块执行完成
 output [105:0] EXE_MEM_bus, // EXE->MEM 总线

 //展示PC
 output [ 31:0] EXE_pc
 );
 //-----{ID->EXE 总线}begin
 //EXE 需要用到的信息
 //ALU 两个源操作数和控制信号
 wire [11:0] alu_control;
 wire [31:0] alu_operand1;
 wire [31:0] alu_operand2;

 //访存需要用到的load/store 信息
 wire [3:0] mem_control; //MEM 需要使用的控制信号
 wire [31:0] store_data; //store 操作的存的数据

 //写回需要用到的信息
 wire rf_wen; //写回的寄存器写使能
 wire [4:0] rf_wdest; //写回的目的寄存器

 //pc
 wire [31:0] pc;
 assign {alu_control,
 alu_operand1,
 alu_operand2,
 mem_control,
 store_data,
 rf_wen,
 rf_wdest,
 pc } = ID_EXE_bus_r;
 //-----{ID->EXE 总线}end

 //-----{ALU}begin
 wire [31:0] alu_result;

 alu alu_module(
 .alu_control (alu_control ), // I, 12, ALU 控制信号
 .alu_src1 (alu_operand1), // I, 32, ALU 操作数1
 .alu_src2 (alu_operand2), // I, 32, ALU 操作数2
 .alu_result (alu_result ) // O, 32, ALU 结果
 );
 //-----{ALU}end

 //-----{EXE 执行完成}begin
 //由于是多周期的，不存在数据相关
 //且所有ALU 运算都可在一拍内完成
 //故EXE 模块一拍就能完成所有操作
 //故EXE_valid 即是EXE_over 信号
 assign EXE_over = EXE_valid;
 //-----{EXE 执行完成}end

 //-----{EXE->MEM 总线}begin
 assign EXE_MEM_bus = {mem_control,store_data, //load/store 信息和store 数据
 alu_result, //alu 运算结果
 rf_wen,rf_wdest, // WB 需要使用的信号
 pc}; // PC
 //-----{EXE->MEM 总线}end

 //-----{展示EXE 模块的PC 值}begin
 assign EXE_pc = pc;
 //-----{展示EXE 模块的PC 值}end
 endmodule

 