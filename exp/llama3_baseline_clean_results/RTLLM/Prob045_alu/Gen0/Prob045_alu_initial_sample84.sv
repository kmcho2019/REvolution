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

reg [31:0] res;
wire signed [31:0] sa = a;
wire signed [31:0] sb = b;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, res} = sa + sb;
            overflow = (sa[31] == sb[31] && sa[31] != res[31]);
        end
        ADDU: begin
            {carry, res} = a + b;
        end
        SUB: begin
            {carry, res} = sa - sb;
            overflow = (sa[31] != sb[31] && sa[31] != res[31]);
        end
        SUBU: begin
            {carry, res} = a - b;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (sa < sb) ? 1 : 0;
        SLTU: res = (a < b) ? 1 : 0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = sa >>> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = sa >>> b;
        LUI: res = {b[15:0], 16'b0};
        default: res = 32'z;
    endcase
end

assign r = res;
assign zero = (res == 0) ? 1'b1 : 1'b0;
assign negative = res[31];
assign flag = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;

endmodule