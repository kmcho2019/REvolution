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

// Internal wires
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] nor_result;
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;
wire [31:0] slt_result;
wire [31:0] sltu_result;
wire [31:0] lui_result;

// Adder module
adder adder_module(
    .a(a),
    .b(b),
    .result(add_result)
);

// Subtractor module
subtractor subtractor_module(
    .a(a),
    .b(b),
    .result(sub_result)
);

// Logical operations
assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nor_result = ~(a | b);

// Shift operations
assign sll_result = a << b[4:0];
assign srl_result = a >> b[4:0];
assign sra_result = a >>> b[4:0];

// Comparison operations
assign slt_result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
assign sltu_result = (a < b) ? 32'd1 : 32'd0;

// LUI operation
assign lui_result = {a[15:0], 16'd0};

// Output multiplexer
assign r = (aluc == ADD) ? add_result :
           (aluc == ADDU) ? add_result :
           (aluc == SUB) ? sub_result :
           (aluc == SUBU) ? sub_result :
           (aluc == AND) ? and_result :
           (aluc == OR) ? or_result :
           (aluc == XOR) ? xor_result :
           (aluc == NOR) ? nor_result :
           (aluc == SLL) ? sll_result :
           (aluc == SRL) ? srl_result :
           (aluc == SRA) ? sra_result :
           (aluc == SLT) ? slt_result :
           (aluc == SLTU) ? sltu_result :
           (aluc == LUI) ? lui_result :
           32'bx;

// Flag calculations
assign zero = (r == 32'd0);
assign negative = r[31];
assign carry = (aluc == ADDU) ? (add_result[31] == 1'b1) :
                (aluc == SUBU) ? (sub_result[31] == 1'b1) :
                1'bx;
assign overflow = (aluc == ADD) ? ((a[31] != b[31]) && (a[31] != add_result[31])) :
                   (aluc == SUB) ? ((a[31] == b[31]) && (a[31] != sub_result[31])) :
                   1'bx;
assign flag = (aluc == SLT) ? (signed'(a) < signed'(b)) :
               (aluc == SLTU) ? (a < b) :
               1'bx;

endmodule

module adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);

assign result = a + b;

endmodule

module subtractor(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);

assign result = a - b;

endmodule