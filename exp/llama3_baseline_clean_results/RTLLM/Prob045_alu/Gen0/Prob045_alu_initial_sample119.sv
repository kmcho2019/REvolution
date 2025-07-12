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

wire [31:0] res;
wire [31:0] signed_a;
wire [31:0] signed_b;

assign signed_a = a;
assign signed_b = b;

always @(*) begin
    case(aluc)
        ADD: res = signed_a + signed_b;
        ADDU: res = a + b;
        SUB: res = signed_a - signed_b;
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed_a < signed_b)? 32'd1 : 32'd0;
        SLTU: res = (a < b)? 32'd1 : 32'd0;
        SLL: res = a << 5'b0;
        SRL: res = a >> 5'b0;
        SRA: res = signed_a >>> 5'b0;
        SLLV: res = a << b[4:0];
        SRLV: res = a >> b[4:0];
        SRAV: res = signed_a >>> b[4:0];
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign zero = (res == 32'd0);
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31]!= res[30]);
assign negative = (res[31] == 1'b1);
assign overflow = (aluc == ADD || aluc == SUB) && (signed_a[31] == signed_b[31]) && (signed_a[31]!= res[31]);
assign flag = (aluc == SLT || aluc == SLTU)? res[0] : 1'bz;

endmodule