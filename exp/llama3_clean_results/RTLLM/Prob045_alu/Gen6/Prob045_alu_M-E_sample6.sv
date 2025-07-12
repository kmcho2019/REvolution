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
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Arithmetic sub-module
module arithmetic(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

reg [31:0] add_result;
reg [31:0] sub_result;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            add_result = a + b;
            result = add_result;
            carry = (add_result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = ((a[31] == b[31]) && (a[31] != add_result[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            add_result = a + b;
            result = add_result;
            carry = (add_result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        SUB: begin
            sub_result = a - b;
            result = sub_result;
            carry = (sub_result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = ((a[31] != b[31]) && (a[31] != sub_result[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            sub_result = a - b;
            result = sub_result;
            carry = (sub_result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        default: result = 32'bx;
    endcase
end

endmodule

// Logical sub-module
module logical(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(a, b, aluc) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bx;
    endcase
end

endmodule

// Shift sub-module
module shift(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(a, b, aluc) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << b[4:0];
        SRLV: result = a >> b[4:0];
        SRAV: result = a >>> b[4:0];
        default: result = 32'bx;
    endcase
end

endmodule

// Flag calculation module
module flags(
    input [31:0] result,
    input [5:0] aluc,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

always @(result, aluc) begin
    zero = (result == 32'd0) ? 1'b1 : 1'b0;
    carry = (result[31] == 1'b1) ? 1'b1 : 1'b0;
    negative = (result[31] == 1'b1) ? 1'b1 : 1'b0;
    overflow = ((result[31] == 1'b1) && (a[31] != b[31])) ? 1'b1 : 1'b0;
    flag = (aluc == SLT || aluc == SLTU) ? (result != 32'd0) : 1'b0;
end

endmodule

// ALU main module
reg [31:0] arithmetic_result;
reg [31:0] logical_result;
reg [31:0] shift_result;

arithmetic arithmetic_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(arithmetic_result),
    .carry(carry),
    .overflow(overflow)
);

logical logical_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(logical_result)
);

shift shift_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(shift_result)
);

flags flags_inst(
    .result(r),
    .aluc(aluc),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow(overflow),
    .flag(flag)
);

always @(aluc) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: r = arithmetic_result;
        AND, OR, XOR, NOR: r = logical_result;
        SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
        LUI: r = {16'b0, a[15:0]};
        default: r = 32'bx;
    endcase
end

endmodule