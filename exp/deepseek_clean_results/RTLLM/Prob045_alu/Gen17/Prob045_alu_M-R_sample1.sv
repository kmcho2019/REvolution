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

    // Precompute all possible results
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire [31:0] and_result = a & b;
    wire [31:0] or_result = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);
    wire [31:0] slt_result = {31'b0, $signed(a) < $signed(b)};
    wire [31:0] sltu_result = {31'b0, a < b};
    
    // Unified shift amount calculation
    wire [4:0] shamt = (aluc[3] && aluc[1:0] != 2'b00) ? a[4:0] : b[4:0];
    wire [31:0] sll_result = b << shamt;
    wire [31:0] srl_result = b >> shamt;
    wire [31:0] sra_result = $signed(b) >>> shamt;
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result selection multiplexer
    assign r = (aluc == ADD || aluc == ADDU) ? add_result[31:0] :
              (aluc == SUB || aluc == SUBU) ? sub_result[31:0] :
              (aluc == AND) ? and_result :
              (aluc == OR) ? or_result :
              (aluc == XOR) ? xor_result :
              (aluc == NOR) ? nor_result :
              (aluc == SLT) ? slt_result :
              (aluc == SLTU) ? sltu_result :
              (aluc == SLL || aluc == SLLV) ? sll_result :
              (aluc == SRL || aluc == SRLV) ? srl_result :
              (aluc == SRA || aluc == SRAV) ? sra_result :
              (aluc == LUI) ? lui_result :
              32'bz; // High-Z for invalid opcodes

    // Flag generation
    assign flag = (aluc == SLT) ? slt_result[0] :
                 (aluc == SLTU) ? sltu_result[0] :
                 1'b0;
    assign zero = (r == 0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_result[32] :
                  (aluc == SUB || aluc == SUBU) ? sub_result[32] :
                  1'b0;
    assign negative = r[31];
    
    // Overflow detection
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire r_sign = r[31];
    assign overflow = (aluc == ADD && (a_sign == b_sign) && (r_sign != a_sign)) ||
                     (aluc == SUB && (a_sign != b_sign) && (r_sign != a_sign));

endmodule