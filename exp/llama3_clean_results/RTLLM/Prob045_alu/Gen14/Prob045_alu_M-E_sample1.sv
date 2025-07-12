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

// Define the modules
arithmetic_module am(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(am_result),
    .carry(am_carry),
    .overflow(am_overflow)
);

logical_module lm(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(lm_result)
);

shift_module sm(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(sm_result)
);

comparison_module cm(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(cm_result),
    .flag(cm_flag)
);

control_module ctm(
    .aluc(aluc),
    .am_result(am_result),
    .lm_result(lm_result),
    .sm_result(sm_result),
    .cm_result(cm_result),
    .cm_flag(cm_flag),
    .am_carry(am_carry),
    .am_overflow(am_overflow),
    .r(r),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow(overflow),
    .flag(flag)
);

endmodule

module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

always @(*) begin
    case (aluc)
        ADD: begin
            result = a + b;
            carry = (a[31] == b[31]) && (result[31] != a[31]);
            overflow = (a[31] == b[31]) && (result[31] != a[31]);
        end
        SUB: begin
            result = a - b;
            carry = (a[31] != b[31]) && (result[31] == a[31]);
            overflow = (a[31] != b[31]) && (result[31] == a[31]);
        end
        default: begin
            result = 32'bx;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule

module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(*) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bx;
    endcase
end

endmodule

module shift_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(*) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        default: result = 32'bx;
    endcase
end

endmodule

module comparison_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg flag
);

always @(*) begin
    case (aluc)
        SLT: begin
            result = (signed'(a) < signed'(b)) ? 1 : 0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            result = (a < b) ? 1 : 0;
            flag = (a < b);
        end
        default: begin
            result = 32'bx;
            flag = 1'b0;
        end
    endcase
end

endmodule

module control_module(
    input [5:0] aluc,
    input [31:0] am_result,
    input [31:0] lm_result,
    input [31:0] sm_result,
    input [31:0] cm_result,
    input cm_flag,
    input am_carry,
    input am_overflow,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

always @(*) begin
    case (aluc)
        ADD, SUB: begin
            r = am_result;
            carry = am_carry;
            overflow = am_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = lm_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL, SRL, SRA: begin
            r = sm_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT, SLTU: begin
            r = cm_result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = cm_flag;
        end
        default: begin
            r = 32'bx;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'h0);
    negative = r[31];
end

endmodule