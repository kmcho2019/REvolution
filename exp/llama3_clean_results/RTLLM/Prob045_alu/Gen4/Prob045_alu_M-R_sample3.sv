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
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Internal signals
wire [31:0] result;
wire [31:0] res;

assign res = (aluc == LUI)? {a[15:0], 16'd0} : (aluc == SLL)? (a << b[4:0]) :
             (aluc == SRL)? (a >> b[4:0]) : (aluc == SRA)? (a >>> b[4:0]) :
             (aluc == SLLV)? (a << a[4:0]) : (aluc == SRLV)? (a >> a[4:0]) :
             (aluc == SRAV)? (a >>> a[4:0]) : 32'd0;

assign result = (aluc == ADD)? a + b :
                (aluc == ADDU)? a + b :
                (aluc == SUB)? a - b :
                (aluc == SUBU)? a - b :
                (aluc == AND)? a & b :
                (aluc == OR)? a | b :
                (aluc == XOR)? a ^ b :
                (aluc == NOR)? ~(a | b) :
                (aluc == SLT)? (a < b)? 32'd1 : 32'd0 :
                (aluc == SLTU)? (a < b)? 32'd1 : 32'd0 :
                res;

assign r = result;

assign zero = (result == 32'd0);
assign carry = ((aluc == ADD || aluc == ADDU) && (result[31]!= a[31])) || ((aluc == SUB || aluc == SUBU) && (result[31]!= a[31]));
assign negative = result[31];
assign overflow = ((aluc == ADD || aluc == ADDU) && (a[31] == b[31]) && (a[31]!= result[31])) || ((aluc == SUB || aluc == SUBU) && (a[31]!= b[31]) && (a[31]!= result[31]));
assign flag = (aluc == SLT || aluc == SLTU);

endmodule