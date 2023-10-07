`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/04 23:59:47
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    // Inputs
        reg clk;
        reg resetn;
        reg [4:0] rf_addr;
        reg [31:0] mem_addr;
    
        // Outputs
        wire [31:0] rf_data;
        wire [31:0] mem_data;
        wire [31:0] IF_pc;
        wire [31:0] IF_inst;
        wire [31:0] ID_pc;
        wire [31:0] EXE_pc;
        wire [31:0] MEM_pc;
        wire [31:0] WB_pc;
        wire [31:0] display_state;
    
        // Instantiate the Unit Under Test (UUT)
        multi_cycle_cpu uut (
            .clk(clk), 
            .resetn(resetn), 
            .rf_addr(rf_addr), 
            .mem_addr(mem_addr), 
            .rf_data(rf_data), 
            .mem_data(mem_data), 
            .IF_pc(IF_pc), 
            .IF_inst(IF_inst), 
            .ID_pc(ID_pc), 
            .EXE_pc(EXE_pc), 
            .MEM_pc(MEM_pc), 
            .WB_pc(WB_pc), 
            .display_state(display_state)
        );
    
        initial begin
            // Initialize Inputs
            clk = 0;
            resetn = 0;
            rf_addr = 0;
            mem_addr = 0;
    
            // Wait 100 ns for global reset to finish
            #100;
          resetn = 1;
            // Add stimulus here
        end
       always #5 clk=~clk;
endmodule
