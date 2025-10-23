module alu(
    input [31:0] a, b,
    input [5:0] aluc,
    output [31:0] r,
    output zero, carry, negative, overflow, flag
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
wire signed [31:0] sa, sb;
wire [31:0] unsigned_a, unsigned_b;

assign sa = a;
assign sb = b;
assign unsigned_a = a;
assign unsigned_b = b;

assign zero = (r == 32'd0);
assign negative = r[31];
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (sa[31] != sb[31] && res[31] != sa[31]);
assign overflow = ((aluc == ADD || aluc == SUB) && (sa[31] == sb[31] && res[31] != sa[31]));

always @(*) begin
    case(aluc)
        ADD: res = sa + sb;
        ADDU: res = unsigned_a + unsigned_b;
        SUB: res = sa - sb;
        SUBU: res = unsigned_a - unsigned_b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (sa < sb) ? 1 : 0;
        SLTU: res = (unsigned_a < unsigned_b) ? 1 : 0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = sa >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = sa >>> a[4:0];
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign flag = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;

endmodule