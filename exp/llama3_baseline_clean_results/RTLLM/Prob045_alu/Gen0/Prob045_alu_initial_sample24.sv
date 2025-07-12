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

wire [31:0] signed_a;
wire [31:0] signed_b;
wire [31:0] res;

assign signed_a = a;
assign signed_b = b;

always @(a, b, aluc) begin
    case (aluc)
        ADD: res = signed_a + signed_b;
        ADDU: res = a + b;
        SUB: res = signed_a - signed_b;
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed_a < signed_b) ? 1 : 0;
        SLTU: res = (a < b) ? 1 : 0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = signed_a >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = signed_a >>> a[4:0];
        LUI: res = {b[15:0], 16'd0};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign zero = (res == 0);
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && ((a + b) > 32'd4294967295 || (a - b) < 0);
assign negative = (res[31] == 1'b1);
assign overflow = ((aluc == ADD || aluc == SUB) && (signed_a[31] == signed_b[31] && signed_b[31] != res[31]));
assign flag = (aluc == SLT || aluc == SLTU) ? (res[0] == 1'b1) : 1'bz;

endmodule