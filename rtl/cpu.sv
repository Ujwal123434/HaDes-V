/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: cpu.sv
 */



module cpu (
    input logic clk,
    input logic rst,

    wishbone_interface.master memory_fetch_port,
    wishbone_interface.master memory_mem_port,

    input logic external_interrupt_in,
    input logic timer_interrupt_in
);

    // TODO: Delete the following line and implement this module.
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] alu_result;
    logic [31:0] mem_data;
    logic [4:0] rd;
    logic reg_write;
    fetch_stage fetch_stage_inst (
        .clk(clk),
        .rst(rst),
        .memory_fetch_port(memory_fetch_port),
        .pc_out(pc),
        .instruction_out(instruction)
  );
      decode_stage decode_stage_inst (
        .clk(clk),
        .instruction(instruction),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd(rd)
    );
    
    execute_stage execute_stage_inst (
        .clk(clk),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .instruction(instruction),
        .alu_result(alu_result)
    );
     memory_stage memory_stage_inst (
        .clk(clk),
        .alu_result(alu_result),
        .rs2_data(rs2_data),
        .memory_mem_port(memory_mem_port),
        .mem_data(mem_data)
    );
     writeback_stage writeback_stage_inst (
        .clk(clk),
        .alu_result(alu_result),
        .mem_data(mem_data),
        .rd(rd),
        .reg_write(reg_write)
    );

endmodule
