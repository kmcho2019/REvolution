// Top-level ALU module
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

// Decoder
reg [2:0] op;
always @(*) begin
    case (aluc)
        ADD, ADDU: op = 3'b000;
        SUB, SUBU: op = 3'b001;
        AND: op = 3'b010;
        OR: op = 3'b011;
        XOR: op = 3'b100;
        NOR: op = 3'b101;
        SLT, SLTU: op = 3'b110;
        SLL, SRL, SRA, SLLV, SRLV, SRAV: op = 3'b111;
        LUI: op = 3'b000;
        default: op = 3'bxxx;
    endcase
end

// Arithmetic operations
reg [31:0] arith_result;
arith_unit arith_unit_inst(
    .a(a),
    .b(b),
    .op(op),
    .result(arith_result)
);

// Bitwise operations
reg [31:0] bitwise_result;
bitwise_unit bitwise_unit_inst(
    .a(a),
    .b(b),
    .op(op),
    .result(bitwise_result)
);

// Shift operations
reg [31:0] shift_result;
shift_unit shift_unit_inst(
    .a(a),
    .b(b),
    .op(op),
    .result(shift_result)
);

// Comparison operations
reg [31:0] compare_result;
compare_unit compare_unit_inst(
    .a(a),
    .b(b),
    .op(op),
    .result(compare_result)
);

// Flag update module
flag_update flag_update_inst(
    .result(r),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow(overflow),
    .flag(flag)
);

// Pipeline registers
reg [31:0] stage1_result;
reg [31:0] stage2_result;

always @(*) begin
    case (op)
        3'b000: stage1_result = arith_result;
        3'b001: stage1_result = arith_result;
        3'b010: stage1_result = bitwise_result;
        3'b011: stage1_result = bitwise_result;
        3'b100: stage1_result = bitwise_result;
        3'b101: stage1_result = bitwise_result;
        3'b110: stage1_result = compare_result;
        3'b111: stage1_result = shift_result;
        default: stage1_result = 32'bx;
    endcase
    stage2_result = stage1_result;
    r = stage2_result;
end

endmodule

// Arithmetic unit
module arith_unit(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result
);

always @(*) begin
    case (op)
        3'b000: result = a + b;
        3'b001: result = a - b;
        default: result = 32'bx;
    endcase
end

endmodule

// Bitwise unit
module bitwise_unit(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result
);

always @(*) begin
    case (op)
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = ~(a | b);
        default: result = 32'bx;
    endcase
end

endmodule

// Shift unit
module shift_unit(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result
);

always @(*) begin
    case (op)
        3'b111: result = a << b[4:0];
        default: result = 32'bx;
    endcase
end

endmodule

// Compare unit
module compare_unit(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result
);

always @(*) begin
    case (op)
        3'b110: result = (a < b)? 32'h1 : 32'h0;
        default: result = 32'bx;
    endcase
end

endmodule

// Flag update module
module flag_update(
    input [31:0] result,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

always @(*) begin
    zero = (result == 32'h0);
    carry = (result[31] == 1'b1);
    negative = result[31];
    overflow = (result[31] == 1'b1);
    flag = (result[0] == 1'b1);
end

endmodule