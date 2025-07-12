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

    // Intermediate operation results
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] sll_res = b << shift_amt;
    wire [31:0] srl_res = b >> shift_amt;
    wire [31:0] sra_res = $signed(b) >>> shift_amt;
    wire slt_res = $signed(a) < $signed(b);
    wire sltu_res = a < b;

    // Final result selection
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_res :
        (aluc == SUB || aluc == SUBU) ? sub_res :
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, slt_res} :
        (aluc == SLTU) ? {31'b0, sltu_res} :
        (aluc == SLL || aluc == SLLV) ? sll_res :
        (aluc == SRL || aluc == SRLV) ? srl_res :
        (aluc == SRA || aluc == SRAV) ? sra_res :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'bz;

    // Flag generation
    assign carry = 
        ((aluc == ADD || aluc == ADDU) && (add_res < a)) ||
        ((aluc == SUB || aluc == SUBU) && (a < b));

    assign overflow = 
        (aluc == ADD) ? (a[31] == b[31] && r[31] != a[31]) :
        (aluc == SUB) ? (a[31] != b[31] && r[31] != a[31]) :
        1'b0;

    assign negative = r[31];
    assign zero = (r == 0);
    assign flag = 
        (aluc == SLT) ? slt_res :
        (aluc == SLTU) ? sltu_res :
        1'bz;

endmodule