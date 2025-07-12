// arithmetic module
module arithmetic(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] res
);

parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter SLT = 6'b101010;

always @(*) begin
    case (aluc)
        ADD: res = a + b;
        SUB: res = a - b;
        SLT: res = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        default: res = 32'd0;
    endcase
end

endmodule

// bitwise module
module bitwise(
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

// shift module
module shift(
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

// control unit
module control_unit(
    input [5:0] aluc,
    output [1:0] op
);

always @(*) begin
    case (aluc)
        6'b100000, 6'b100010, 6'b101010: op = 2'b00; // arithmetic
        6'b100100, 6'b100101, 6'b100110, 6'b100111: op = 2'b01; // bitwise
        6'b000000, 6'b000010, 6'b000011, 6'b000100, 6'b000110, 6'b000111: op = 2'b10; // shift
        default: op = 2'b11; // unknown
    endcase
end

endmodule

// top-level module
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

wire [1:0] op;
wire [31:0] res_arithmetic;
wire [31:0] res_bitwise;
wire [31:0] res_shift;

control_unit cu(.aluc(aluc),.op(op));
arithmetic ar(.a(a),.b(b),.aluc(aluc),.res(res_arithmetic));
bitwise bw(.a(a),.b(b),.aluc(aluc),.res(res_bitwise));
shift sh(.a(a),.b(b),.aluc(aluc),.res(res_shift));

always @(*) begin
    case (op)
        2'b00: r = res_arithmetic;
        2'b01: r = res_bitwise;
        2'b10: r = res_shift;
        default: r = 32'd0;
    endcase
end

assign zero = (r == 32'd0);
assign carry = (aluc == 6'b100000 || aluc == 6'b100001) && (a[31] == b[31] && a[31]!= r[31]);
assign negative = r[31];
assign overflow = (aluc == 6'b100010 || aluc == 6'b100011) && (a[31]!= b[31] && a[31]!= r[31]);
assign flag = (aluc == 6'b101010 || aluc == 6'b101011) && (r == 32'd1);

endmodule