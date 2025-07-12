module malu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag,
    input clk
);

// Arithmetic Block (AB)
module ab(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op, // 00: ADD, 01: SUB, 10: ADDU, 11: SUBU
    output [31:0] result,
    output carry,
    output overflow
);
    reg [32:0] sum;
    always @(posedge clk) begin
        case (op)
            2'b00: sum = a + b;
            2'b01: sum = a - b;
            2'b10: sum = {1'b0, a} + {1'b0, b};
            2'b11: sum = {1'b0, a} - {1'b0, b};
        endcase
        result = sum[31:0];
        carry = sum[32];
        overflow = (a[31] == b[31] && result[31] != a[31]);
    end
endmodule

// Logical Block (LB)
module lb(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op, // 000: AND, 001: OR, 010: XOR, 011: NOR
    output [31:0] result
);
    always @(posedge clk) begin
        case (op)
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b010: result = a ^ b;
            3'b011: result = ~(a | b);
        endcase
    end
endmodule

// Shift Block (SB)
module sb(
    input [31:0] a,
    input [4:0] shift,
    input [1:0] op, // 00: SLL, 01: SRL, 10: SRA
    output [31:0] result
);
    always @(posedge clk) begin
        case (op)
            2'b00: result = a << shift;
            2'b01: result = a >> shift;
            2'b10: result = a >>> shift;
        endcase
    end
endmodule

// Control Block (CB)
module cb(
    input [5:0] aluc,
    output [1:0] ab_op,
    output [2:0] lb_op,
    output [1:0] sb_op,
    output flag
);
    always @(posedge clk) begin
        case (aluc)
            ADD, ADDU: ab_op = (aluc == ADD) ? 2'b00 : 2'b10;
            SUB, SUBU: ab_op = (aluc == SUB) ? 2'b01 : 2'b11;
            AND: lb_op = 3'b000;
            OR: lb_op = 3'b001;
            XOR: lb_op = 3'b010;
            NOR: lb_op = 3'b011;
            SLT: flag = (signed'(a) < signed'(b)) ? 1'b1 : 1'b0;
            SLTU: flag = (a < b) ? 1'b1 : 1'b0;
            SLL, SRL, SRA: sb_op = (aluc == SLL) ? 2'b00 : (aluc == SRL) ? 2'b01 : 2'b10;
        endcase
    end
endmodule

// MALU Instantiation
ab ab_inst(
    .a(a),
    .b(b),
    .op(cb.ab_op),
    .result(ab_result),
    .carry(carry),
    .overflow(overflow)
);

lb lb_inst(
    .a(a),
    .b(b),
    .op(cb.lb_op),
    .result(lb_result)
);

sb sb_inst(
    .a(a),
    .shift(b[4:0]),
    .op(cb.sb_op),
    .result(sb_result)
);

cb cb_inst(
    .aluc(aluc),
    .ab_op(),
    .lb_op(),
    .sb_op(),
    .flag(flag)
);

// Output Multiplexing
always @(posedge clk) begin
    case (aluc)
        ADD, SUB, ADDU, SUBU: r = ab_result;
        AND, OR, XOR, NOR: r = lb_result;
        SLL, SRL, SRA: r = sb_result;
        SLT, SLTU: r = 32'h0;
    endcase
    zero = (r == 32'h0);
    negative = r[31];
end

endmodule