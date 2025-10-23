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

// Calculate result
wire [31:0] add_res, sub_res;
assign add_res = a + b;
assign sub_res = a - b;

assign r = (aluc == ADD || aluc == ADDU) ? add_res :
           (aluc == SUB || aluc == SUBU) ? sub_res :
           (aluc == AND) ? (a & b) :
           (aluc == OR) ? (a | b) :
           (aluc == XOR) ? (a ^ b) :
           (aluc == NOR) ? ~(a | b) :
           (aluc == SLL) ? (a << b[4:0]) :
           (aluc == SRL) ? (a >> b[4:0]) :
           (aluc == SRA) ? (a >>> b[4:0]) :
           (aluc == LUI) ? {16'b0, a[15:0]} :
           32'bx;

// Calculate flags
assign zero = (r == 32'd0);
assign carry = ((aluc == ADD || aluc == ADDU) && (add_res[31] == 1'b1)) ||
              ((aluc == SUB || aluc == SUBU) && (sub_res[31] == 1'b1));
assign negative = r[31];
assign overflow = ((aluc == ADD) && (a[31] != b[31]) && (a[31] != r[31])) ||
                 ((aluc == SUB) && (a[31] != b[31]) && (a[31] != r[31]));
assign flag = ((aluc == SLT) && ($signed(a) < $signed(b))) ||
             ((aluc == SLTU) && (a < b));

endmodule