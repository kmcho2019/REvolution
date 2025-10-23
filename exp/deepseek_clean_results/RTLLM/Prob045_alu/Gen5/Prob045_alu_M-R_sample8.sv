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

    // Signed versions of inputs
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    
    // Shift amount selection
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    
    // Operation results
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amount : 32'b0;
    
    // Main result selection
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_result[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_result[31:0] :
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, a_signed < b_signed} :
        (aluc == SLTU)? {31'b0, a < b} :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        ((aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
         (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV)) ? shift_result : 32'b0;

    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = 
        ((aluc == ADD || aluc == ADDU) && add_result[32]) ||
        ((aluc == SUB || aluc == SUBU) && sub_result[32]);
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 1'b0;
    assign flag = 
        (aluc == SLT) ? (a_signed < b_signed) :
        (aluc == SLTU)? (a < b) : 1'b0;

endmodule