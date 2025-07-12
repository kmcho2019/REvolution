module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Operation Group Detection
    wire arithmetic_op = (aluc[5:3] == 3'b100);
    wire logical_op = (aluc[5:3] == 3'b100) && (aluc[2:0] >= 4 && aluc[2:0] <= 7);
    wire shift_op = (aluc[5:4] == 2'b00);
    wire special_op = (aluc == SLT || aluc == SLTU || aluc == LUI);

    // Group 1: Arithmetic Operations (Parallel Computation)
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} + {1'b0, ~b} + 33'b1;
    wire [31:0] arith_result = (aluc[0] ? add_res[31:0] : sub_res[31:0]);
    wire arith_carry = (aluc[0] ? add_res[32] : sub_res[32]);
    wire arith_overflow = (aluc == ADD) ? (a[31] == b[31]) && (arith_result[31] != a[31]) :
                        (aluc == SUB) ? (a[31] != b[31]) && (arith_result[31] != a[31]) : 1'b0;

    // Group 2: Logical Operations (Parallel Computation)
    wire [31:0] and_res = a & b;
    wire [31:0] or_res = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);
    wire [31:0] logical_result = 
        (aluc[1:0] == 2'b00) ? and_res :
        (aluc[1:0] == 2'b01) ? or_res :
        (aluc[1:0] == 2'b10) ? xor_res : nor_res;

    // Group 3: Shift Operations (Unified Barrel Shifter)
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);
    wire [31:0] shift_result = 
        (aluc[1:0] == 2'b00) ? b << shift_amount :
        (aluc[1:0] == 2'b10) ? b >> shift_amount :
        $signed(b) >>> shift_amount;

    // Group 4: Special Operations
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    wire [31:0] special_result = 
        (aluc == SLT) ? {31'b0, slt_res} :
        (aluc == SLTU) ? {31'b0, sltu_res} :
        {b[15:0], 16'b0};  // LUI

    // Hierarchical Result Selection
    wire [31:0] group_results [0:3];
    assign group_results[0] = arith_result;
    assign group_results[1] = logical_result;
    assign group_results[2] = shift_result;
    assign group_results[3] = special_result;
    
    wire [1:0] group_select = 
        arithmetic_op ? 2'b00 :
        logical_op ? 2'b01 :
        shift_op ? 2'b10 : 2'b11;
    
    assign r = group_results[group_select];

    // Flag Generation
    assign zero = ~|r;
    assign negative = r[31];
    assign carry = arithmetic_op ? arith_carry : 1'b0;
    assign overflow = arithmetic_op ? arith_overflow : 1'b0;
    assign flag = (aluc == SLT) ? slt_res : 
                 (aluc == SLTU) ? sltu_res : 1'b0;

endmodule