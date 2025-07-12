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

    // Intermediate signals
    wire [31:0] b_shift = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a : b;
    wire [4:0] shamt = b_shift[4:0];
    wire [32:0] add_result = a + b;
    wire [32:0] sub_result = a - b;
    
    // Operation results
    wire [31:0] add_res = add_result[31:0];
    wire [31:0] sub_res = sub_result[31:0];
    wire [31:0] and_res = a & b;
    wire [31:0] or_res = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);
    wire [31:0] slt_res = ($signed(a) < $signed(b)) ? 1 : 0;
    wire [31:0] sltu_res = a < b ? 1 : 0;
    wire [31:0] sll_res = b << shamt;
    wire [31:0] srl_res = b >> shamt;
    wire [31:0] sra_res = $signed(b) >>> shamt;
    wire [31:0] lui_res = {b[15:0], 16'b0};

    // Result selection
    assign r = (aluc == ADD || aluc == ADDU) ? add_res :
              (aluc == SUB || aluc == SUBU) ? sub_res :
              (aluc == AND) ? and_res :
              (aluc == OR) ? or_res :
              (aluc == XOR) ? xor_res :
              (aluc == NOR) ? nor_res :
              (aluc == SLT) ? slt_res :
              (aluc == SLTU) ? sltu_res :
              (aluc == SLL || aluc == SLLV) ? sll_res :
              (aluc == SRL || aluc == SRLV) ? srl_res :
              (aluc == SRA || aluc == SRAV) ? sra_res :
              (aluc == LUI) ? lui_res :
              32'b0;

    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_result[32] : 
                  (aluc == SUB || aluc == SUBU) ? sub_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                     ((aluc == SUB) && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule