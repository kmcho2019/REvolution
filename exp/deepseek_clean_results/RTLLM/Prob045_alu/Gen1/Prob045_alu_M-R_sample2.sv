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

    // Internal signals
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shamt = b[4:0];
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    
    // Result calculation
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_res[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_res[31:0] :
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, a_signed < b_signed} :
        (aluc == SLTU) ? {31'b0, a < b} :
        (aluc == SLL) ? b << a[4:0] :
        (aluc == SRL) ? b >> a[4:0] :
        (aluc == SRA) ? $signed(b) >>> a[4:0] :
        (aluc == SLLV) ? b << shamt :
        (aluc == SRLV) ? b >> shamt :
        (aluc == SRAV) ? $signed(b) >>> shamt :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'bz;  // Undefined operation

    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_res[32] :
        (aluc == SUB || aluc == SUBU) ? sub_res[32] : 
        1'b0;
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD) ? ((a_signed[31] == b_signed[31]) && (r[31] != a_signed[31])) :
        (aluc == SUB) ? ((a_signed[31] != b_signed[31]) && (r[31] != a_signed[31]) :
        1'b0;
    assign flag = 
        (aluc == SLT) ? (a_signed < b_signed) :
        (aluc == SLTU) ? (a < b) :
        1'bz;

endmodule