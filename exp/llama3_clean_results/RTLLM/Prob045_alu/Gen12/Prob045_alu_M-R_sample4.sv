module alu_add_sub(
    input [31:0] a,
    input [31:0] b,
    input add_sub, // 1 for add, 0 for sub
    output [31:0] r,
    output carry,
    output overflow
);

assign {carry, r} = add_sub ? (a + b) : (a - b);
assign overflow = (a[31] != b[31] && r[31] != a[31]);

endmodule

module alu_logic(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op, // 0: and, 1: or, 2: xor, 3: nor
    output [31:0] r
);

always @(a, b, op) begin
    case (op)
        2'b00: r = a & b;
        2'b01: r = a | b;
        2'b10: r = a ^ b;
        2'b11: r = ~(a | b);
    endcase
end

endmodule

module alu_shift(
    input [31:0] a,
    input [4:0] shift,
    input [1:0] op, // 0: sll, 1: srl, 2: sra
    output [31:0] r
);

always @(a, shift, op) begin
    case (op)
        2'b00: r = a << shift;
        2'b01: r = a >> shift;
        2'b10: r = a >>> shift;
    endcase
end

endmodule

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
assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

alu_add_sub add_sub(
    .a(a),
    .b(b),
    .add_sub(aluc == ADD || aluc == ADDU),
    .r(add_sub_r),
    .carry(add_sub_carry),
    .overflow(add_sub_overflow)
);

alu_logic logic(
    .a(a),
    .b(b),
    .op({aluc[4], aluc[3]}),
    .r(logic_r)
);

alu_shift shift(
    .a(a),
    .shift(b[4:0]),
    .op({aluc[1], aluc[0]}),
    .r(shift_r)
);

always @(a, b, aluc) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = add_sub_r;
            carry = add_sub_carry;
            overflow = add_sub_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logic_r;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: r = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
        SLTU: r = (a < b) ? 32'h1 : 32'h0;
        SLL, SRL, SRA: r = shift_r;
        SLLV, SRLV, SRAV: r = shift_r;
        LUI: r = {16'd0, a[15:0]};
        default: r = 32'bz;
    endcase
end

endmodule