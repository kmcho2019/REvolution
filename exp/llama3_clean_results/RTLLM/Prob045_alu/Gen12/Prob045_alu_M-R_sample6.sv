module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Define operation codes
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
parameter LUI = 6'b001111;

// Arithmetic operations
assign r = (aluc == ADD)? a + b :
           (aluc == ADDU)? a + b :
           (aluc == SUB)? a - b :
           (aluc == SUBU)? a - b :
           // Logical operations
           (aluc == AND)? a & b :
           (aluc == OR)? a | b :
           (aluc == XOR)? a ^ b :
           (aluc == NOR)? ~(a | b) :
           // Shift operations
           (aluc == SLL)? a << b[4:0] :
           (aluc == SRL)? a >> b[4:0] :
           (aluc == SRA)? a >>> b[4:0] :
           // Load Upper Immediate
           (aluc == LUI)? {16'b0, a[15:0]} :
           32'bx;

// Flag calculations
assign zero = (r == 32'd0);
assign carry = ((aluc == ADD || aluc == ADDU) && (a[31]!= b[31]) && (a[31]!= r[31]))? 1'b1 : 1'b0;
assign negative = r[31];
assign overflow = ((aluc == ADD || aluc == SUB) && (a[31]!= b[31]) && (a[31]!= r[31]))? 1'b1 : 1'b0;
assign flag = (aluc == SLT)? ($signed(a) < $signed(b)) :
               (aluc == SLTU)? (a < b) :
               1'b0;

endmodule