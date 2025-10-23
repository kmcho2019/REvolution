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

    // Operation codes (same as original)
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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};

    // Result calculation
    assign r = 
        (aluc == ADD)  ? (a + b) :
        (aluc == ADDU) ? (a + b) :
        (aluc == SUB)  ? (a - b) :
        (aluc == SUBU) ? (a - b) :
        (aluc == AND)  ? (a & b) :
        (aluc == OR)   ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT)  ? (signed_a < signed_b) :
        (aluc == SLTU) ? (a < b) :
        (aluc == SLL)  ? (b << shift_amt) :
        (aluc == SRL)  ? (b >> shift_amt) :
        (aluc == SRA)  ? (signed_b >>> shift_amt) :
        (aluc == SLLV) ? (b << a[4:0]) :
        (aluc == SRLV) ? (b >> a[4:0]) :
        (aluc == SRAV) ? (signed_b >>> a[4:0]) :
        (aluc == LUI)  ? {b[15:0], 16'b0} :
        32'b0;

    // Flag outputs
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_result[32] :
        (aluc == SUB || aluc == SUBU) ? sub_result[32] :
        1'b0;

    assign overflow = 
        (aluc == ADD) ? ((a[31] == b[31]) && (r[31] != a[31])) :
        (aluc == SUB) ? ((a[31] != b[31]) && (r[31] != a[31])) :
        1'b0;

    assign flag = 
        (aluc == SLT || aluc == SLTU) ? r[0] :
        1'b0;

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule