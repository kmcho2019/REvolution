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

wire [31:0] add_sub_r;
wire add_sub_carry;
wire add_sub_overflow;

wire [31:0] logic_r;

wire [31:0] shift_r;

assign zero = (r == 32'h0);
assign negative = r[31];
assign flag = (aluc == SLT || aluc == SLTU)? (a < b) : 1'b0;

// Addition and Subtraction
assign {add_sub_carry, add_sub_r} = (aluc == ADD || aluc == ADDU)? (a + b) : (a - b);
assign add_sub_overflow = (a[31]!= b[31] && add_sub_r[31]!= a[31]);

// Logical Operations
assign logic_r = (aluc == AND)? (a & b) :
                 (aluc == OR)? (a | b) :
                 (aluc == XOR)? (a ^ b) :
                 (aluc == NOR)? ~(a | b) : 32'bz;

// Shift Operations
assign shift_r = (aluc == SLL)? (a << b[4:0]) :
                (aluc == SRL)? (a >> b[4:0]) :
                (aluc == SRA)? (a >>> b[4:0]) : 32'bz;

// ALU Operation Selection
assign r = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? add_sub_r :
           (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR)? logic_r :
           (aluc == SLT)? ({31'b0, (signed'(a) < signed'(b))}) :
           (aluc == SLTU)? ({31'b0, (a < b)}) :
           (aluc == SLL || aluc == SRL || aluc == SRA)? shift_r :
           (aluc == LUI)? ({a[15:0], 16'd0}) : 32'bz;

assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? add_sub_carry : 1'b0;
assign overflow = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? add_sub_overflow : 1'b0;

endmodule