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

// Arithmetic functional unit
module arithmetic_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output carry,
    output overflow
);

reg [31:0] res;
reg carry_out;
reg overflow_out;

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            {carry_out, res} = a + (aluc == ADDU ? b : b);
            overflow_out = (aluc == ADD) && (a[31] == b[31] && a[31] != res[31]);
        end
        SUB, SUBU: begin
            {carry_out, res} = a - (aluc == SUBU ? b : b);
            overflow_out = (aluc == SUB) && (a[31] != b[31] && a[31] != res[31]);
        end
    endcase

    carry = carry_out;
    overflow = overflow_out;
    r = res;
end

endmodule

// Bitwise functional unit
module bitwise_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r
);

reg [31:0] res;

always @(*) begin
    case (aluc)
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
    endcase

    r = res;
end

endmodule

// Shift functional unit
module shift_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r
);

reg [31:0] res;

always @(*) begin
    case (aluc)
        SLL, SLLV: res = (aluc == SLL) ? a << b[4:0] : a << b;
        SRL, SRLV: res = (aluc == SRL) ? a >> b[4:0] : a >> b;
        SRA, SRAV: res = (aluc == SRA) ? a >>> b[4:0] : a >>> b;
    endcase

    r = res;
end

endmodule

// Control unit
module control_unit(
    input [5:0] aluc,
    output [2:0] func
);

reg [2:0] func_out;

always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: func_out = 3'b000;
        AND, OR, XOR, NOR: func_out = 3'b001;
        SLL, SRL, SRA, SLLV, SRLV, SRAV: func_out = 3'b010;
        SLT, SLTU: func_out = 3'b011;
        LUI: func_out = 3'b100;
    endcase

    func = func_out;
end

endmodule

// Multiplexer
module multiplexer(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [2:0] func,
    output [31:0] r
);

reg [31:0] res;

always @(*) begin
    case (func)
        3'b000: res = a;
        3'b001: res = b;
        3'b010: res = c;
        3'b011: res = d;
        3'b100: res = {a[15:0], 16'd0};
    endcase

    r = res;
end

endmodule

// Main ALU module
reg [31:0] res;
reg zero_out;
reg carry_out;
reg negative_out;
reg overflow_out;
reg flag_out;
reg [2:0] func;

arithmetic_unit au(a, b, aluc, res, carry_out, overflow_out);
bitwise_unit bu(a, b, aluc, res);
shift_unit su(a, b, aluc, res);
control_unit cu(aluc, func);
multiplexer mux(au.res, bu.res, su.res, 32'd0, func, res);

always @(*) begin
    zero_out = (res == 32'd0);
    negative_out = res[31];
    flag_out = (aluc == SLT || aluc == SLTU) && (res == 32'd1);
end

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

endmodule