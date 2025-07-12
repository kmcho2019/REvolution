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

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

wire [31:0] result;

// Arithmetic Operations
assign result = (aluc == ADD)? a + b :
                (aluc == ADDU)? a + b :
                (aluc == SUB)? a - b :
                (aluc == SUBU)? a - b :
                32'bz;

// Logical Operations
assign result = (aluc == AND)? a & b :
                (aluc == OR)? a | b :
                (aluc == XOR)? a ^ b :
                (aluc == NOR)? ~(a | b) :
                32'bz;

// Shift Operations
assign result = (aluc == SLL)? a << b[4:0] :
                (aluc == SRL)? a >> b[4:0] :
                (aluc == SRA)? a >>> b[4:0] :
                (aluc == SLLV)? a << a[4:0] :
                (aluc == SRLV)? a >> a[4:0] :
                (aluc == SRAV)? a >>> a[4:0] :
                32'bz;

// Load Upper Immediate
assign result = (aluc == LUI)? {16'd0, b[15:0]} :
                32'bz;

// Set on Less Than
assign result = (aluc == SLT)? (signed'(a) < signed'(b))? 32'h1 : 32'h0 :
                (aluc == SLTU)? (a < b)? 32'h1 : 32'h0 :
                32'bz;

// Output Signals
assign r = result;
assign zero = (result == 32'h0)? 1'b1 : 1'b0;
assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU))?
               ((a[31] == 1'b0 && b[31] == 1'b0 && result[31] == 1'b1) ||
                (a[31] == 1'b1 && b[31] == 1'b1 && result[31] == 1'b0)) : 
               1'b0;
assign negative = result[31];
assign overflow = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU))?
                  ((a[31] == 1'b0 && b[31] == 1'b0 && result[31] == 1'b1) ||
                   (a[31] == 1'b1 && b[31] == 1'b1 && result[31] == 1'b0)) : 
                  1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU))? result[0] : 1'b0;

endmodule