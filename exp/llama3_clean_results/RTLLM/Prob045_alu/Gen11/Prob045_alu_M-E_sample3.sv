// Top-level ALU module
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

// Define operation modules
module add(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    output carry,
    output overflow
);
    assign {carry, r} = a + b;
    assign overflow = (a[31] == b[31] && r[31]!= a[31]);
endmodule

module sub(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    output carry,
    output overflow
);
    assign {carry, r} = a - b;
    assign overflow = (a[31]!= b[31] && r[31]!= a[31]);
endmodule

module and(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r
);
    assign r = a & b;
endmodule

module or(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r
);
    assign r = a | b;
endmodule

module xor(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r
);
    assign r = a ^ b;
endmodule

module nor(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r
);
    assign r = ~(a | b);
endmodule

module slt(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    output flag
);
    assign r = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
    assign flag = r[0];
endmodule

module sltu(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    output flag
);
    assign r = (a < b)? 32'h1 : 32'h0;
    assign flag = r[0];
endmodule

module sll(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a << b;
endmodule

module srl(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a >> b;
endmodule

module sra(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a >>> b;
endmodule

module sllv(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a << b;
endmodule

module srlv(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a >> b;
endmodule

module srav(
    input [31:0] a,
    input [4:0] b,
    output [31:0] r
);
    assign r = a >>> b;
endmodule

module lui(
    input [15:0] a,
    output [31:0] r
);
    assign r = {16'd0, a};
endmodule

// Control unit
module control_unit(
    input [5:0] aluc,
    output [2:0] op,
    output [1:0] flag_op
);
    always @(*) begin
        case (aluc)
            6'b100000: begin op = 3'b000; flag_op = 2'b00; end // ADD
            6'b100001: begin op = 3'b001; flag_op = 2'b00; end // ADDU
            6'b100010: begin op = 3'b010; flag_op = 2'b00; end // SUB
            6'b100011: begin op = 3'b011; flag_op = 2'b00; end // SUBU
            6'b100100: begin op = 3'b100; flag_op = 2'b00; end // AND
            6'b100101: begin op = 3'b101; flag_op = 2'b00; end // OR
            6'b100110: begin op = 3'b110; flag_op = 2'b00; end // XOR
            6'b100111: begin op = 3'b111; flag_op = 2'b00; end // NOR
            6'b101010: begin op = 3'b000; flag_op = 2'b01; end // SLT
            6'b101011: begin op = 3'b001; flag_op = 2'b01; end // SLTU
            default: begin op = 3'b000; flag_op = 2'b00; end
        endcase
    end
endmodule

// Flag generation unit
module flag_generation(
    input [31:0] r,
    input [1:0] flag_op,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);
    assign zero = (r == 32'h0);
    assign negative = r[31];
    assign flag = (flag_op == 2'b01)? r[0] : 1'b0;
endmodule

// Instantiate operation modules
add add_inst(
    .a(a),
    .b(b),
    .r(r_add),
    .carry(carry_add),
    .overflow(overflow_add)
);

sub sub_inst(
    .a(a),
    .b(b),
    .r(r_sub),
    .carry(carry_sub),
    .overflow(overflow_sub)
);

and and_inst(
    .a(a),
    .b(b),
    .r(r_and)
);

or or_inst(
    .a(a),
    .b(b),
    .r(r_or)
);

xor xor_inst(
    .a(a),
    .b(b),
    .r(r_xor)
);

nor nor_inst(
    .a(a),
    .b(b),
    .r(r_nor)
);

slt slt_inst(
    .a(a),
    .b(b),
    .r(r_slt),
    .flag(flag_slt)
);

sltu sltu_inst(
    .a(a),
    .b(b),
    .r(r_sltu),
    .flag(flag_sltu)
);

sll sll_inst(
    .a(a),
    .b(b[4:0]),
    .r(r_sll)
);

srl srl_inst(
    .a(a),
    .b(b[4:0]),
    .r(r_srl)
);

sra sra_inst(
    .a(a),
    .b(b[4:0]),
    .r(r_sra)
);

sllv sllv_inst(
    .a(a),
    .b(a[4:0]),
    .r(r_sllv)
);

srlv srlv_inst(
    .a(a),
    .b(a[4:0]),
    .r(r_srlv)
);

srav srav_inst(
    .a(a),
    .b(a[4:0]),
    .r(r_srav)
);

lui lui_inst(
    .a(a[15:0]),
    .r(r_lui)
);

// Instantiate control unit
control_unit control_unit_inst(
    .aluc(aluc),
    .op(op),
    .flag_op(flag_op)
);

// Instantiate flag generation unit
flag_generation flag_generation_inst(
    .r(r),
    .flag_op(flag_op),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow(overflow),
    .flag(flag)
);

// MUX for selecting operation result
always @(*) begin
    case (op)
        3'b000: r = (flag_op == 2'b01)? (flag_slt? r_slt : r_sltu) : (aluc == 6'b100000? r_add : r_sub);
        3'b001: r = (aluc == 6'b100001)? r_add : r_sub;
        3'b010: r = r_and;
        3'b011: r = r_or;
        3'b100: r = r_xor;
        3'b101: r = r_nor;
        3'b110: r = r_sll;
        3'b111: r = r_srl;
        default: r = r_lui;
    endcase
end

endmodule