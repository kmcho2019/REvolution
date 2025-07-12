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

// Control signals
wire [2:0] op;
wire [1:0] flag_op;

// Control unit
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

// Result selection
assign r = (op == 3'b000)? (flag_op == 2'b01)? (aluc == 6'b101010? r_slt : r_sltu) : (aluc == 6'b100000? r_add : r_sub) :
          (op == 3'b001)? (aluc == 6'b100001? r_add : r_sub) :
          (op == 3'b010)? r_and :
          (op == 3'b011)? r_or :
          (op == 3'b100)? r_xor :
          (op == 3'b101)? r_nor :
          (op == 3'b110)? r_sll :
          (op == 3'b111)? r_srl :
          r_lui;

// Flag generation
assign zero = (r == 32'h0);
assign negative = r[31];
assign flag = (flag_op == 2'b01)? (aluc == 6'b101010? flag_slt : flag_sltu) : 1'b0;
assign carry = (aluc == 6'b100000)? carry_add : (aluc == 6'b100001)? carry_add : (aluc == 6'b100010)? carry_sub : (aluc == 6'b100011)? carry_sub : 1'b0;
assign overflow = (aluc == 6'b100000)? overflow_add : (aluc == 6'b100001)? overflow_add : (aluc == 6'b100010)? overflow_sub : (aluc == 6'b100011)? overflow_sub : 1'b0;

endmodule