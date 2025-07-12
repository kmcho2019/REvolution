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

wire [31:0] arith_res;
wire [31:0] bitwise_res;
wire [31:0] shift_res;
wire [31:0] comp_res;

arith_unit au(
    .a(a),
    .b(b),
    .aluc(aluc),
    .res(arith_res)
);

bitwise_unit bwu(
    .a(a),
    .b(b),
    .aluc(aluc),
    .res(bitwise_res)
);

shift_unit su(
    .a(a),
    .b(b),
    .aluc(aluc),
    .res(shift_res)
);

comp_unit cu(
    .a(a),
    .b(b),
    .aluc(aluc),
    .res(comp_res)
);

always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: r = arith_res;
        AND, OR, XOR, NOR: r = bitwise_res;
        SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_res;
        SLT, SLTU: r = comp_res;
        LUI: r = { a[15:0], 16'd0 };
        default: r = 32'd0;
    endcase
end

assign zero = (r == 32'd0);
assign carry = (aluc == ADD || aluc == ADDU) && (a[31] == b[31] && a[31] != r[31]);
assign negative = r[31];
assign overflow = (aluc == SUB || aluc == SUBU) && (a[31] != b[31] && a[31] != r[31]);
assign flag = (aluc == SLT || aluc == SLTU) && (r == 1);

endmodule

module arith_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] res
);

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;

always @(*) begin
    case (aluc)
        ADD, ADDU: res = a + b;
        SUB, SUBU: res = a - b;
        default: res = 32'd0;
    endcase
end

endmodule

module bitwise_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] res
);

parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

always @(*) begin
    case (aluc)
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        default: res = 32'd0;
    endcase
end

endmodule

module shift_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] res
);

parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

always @(*) begin
    case (aluc)
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = a >>> b;
        default: res = 32'd0;
    endcase
end

endmodule

module comp_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] res
);

parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;

always @(*) begin
    case (aluc)
        SLT: res = (signed'(a) < signed'(b)) ? 1 : 0;
        SLTU: res = (a < b) ? 1 : 0;
        default: res = 32'd0;
    endcase
end

endmodule