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

// Arithmetic operations
wire [31:0] add_result;
wire [31:0] sub_result;
assign add_result = a + b;
assign sub_result = a - b;

// Logical operations
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] nor_result;
assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nor_result = ~(a | b);

// Shift operations
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;
assign sll_result = a << b[4:0];
assign srl_result = a >> b[4:0];
assign sra_result = a >>> b[4:0];

// Select operation result
wire [31:0] result;
assign result = (aluc == ADD)? add_result :
                (aluc == ADDU)? add_result :
                (aluc == SUB)? sub_result :
                (aluc == SUBU)? sub_result :
                (aluc == AND)? and_result :
                (aluc == OR)? or_result :
                (aluc == XOR)? xor_result :
                (aluc == NOR)? nor_result :
                (aluc == SLL)? sll_result :
                (aluc == SRL)? srl_result :
                (aluc == SRA)? sra_result :
                (aluc == LUI)? {16'b0, a[15:0]} : 32'bx;

// Calculate flags
assign zero = (result == 32'd0);
assign carry = (result[31] == 1'b1);
assign negative = (result[31] == 1'b1);
assign overflow = ((aluc == ADD || aluc == SUB) && (a[31]!= b[31]) && (a[31]!= result[31]))? 1'b1 : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU)? (result!= 32'd0) : 1'b0;

// Assign result
assign r = result;

endmodule