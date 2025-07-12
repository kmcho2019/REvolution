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
    wire [31:0] add_res = a + b;
    wire [31:0] addu_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [31:0] subu_res = a - b;
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Barrel shifter
    wire [31:0] shift_res = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        $signed(b) >>> shift_amount;

    // Operation selection
    assign r = 
        (aluc == ADD)  ? add_res :
        (aluc == ADDU) ? addu_res :
        (aluc == SUB)  ? sub_res :
        (aluc == SUBU) ? subu_res :
        (aluc == AND)  ? a & b :
        (aluc == OR)   ? a | b :
        (aluc == XOR)  ? a ^ b :
        (aluc == NOR)  ? ~(a | b) :
        (aluc == SLT)  ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} :
        ((aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
         (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV)) ? shift_res :
        (aluc == LUI)  ? {a[15:0], 16'b0} :
        32'b0;

    // Flag calculations
    assign zero = (r == 0);
    assign negative = r[31];
    assign carry = 
        (aluc == ADD) ? (add_res < a) :
        (aluc == ADDU) ? (addu_res < a) :
        (aluc == SUB) ? (a >= b) :
        (aluc == SUBU) ? (a >= b) :
        1'b0;
    assign overflow = 
        (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) :
        1'b0;
    assign flag = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) :
        1'b0;

endmodule