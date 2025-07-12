module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

reg signed [31:0] sa;
reg signed [31:0] sb;
reg signed [31:0] res;

assign sa = a;
assign sb = b;

always @(a, b, aluc) begin
    case (aluc)
        ADD:  res = sa + sb;
        ADDU: res = a + b;
        SUB:  res = sa - sb;
        SUBU: res = a - b;
        AND:  res = a & b;
        OR:   res = a | b;
        XOR:  res = a ^ b;
        NOR:  res = ~(a | b);
        SLT:  res = (sa < sb) ? 1 : 0;
        SLTU: res = (a < b) ? 1 : 0;
        SLL:  res = a << 5'b00000;
        SRL:  res = a >> 5'b00000;
        SRA:  res = sa >>> 5'b00000;
        SLLV: res = a << b[4:0];
        SRLV: res = a >> b[4:0];
        SRAV: res = sa >>> b[4:0];
        LUI:  res = {a[15:0], 16'b0000000000000000};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign zero = (res == 0) ? 1'b1 : 1'b0;
assign carry = ((aluc == ADD || aluc == ADDU) && (res[31] != a[31])) ? 1'b1 : 1'b0;
assign negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign overflow = ((aluc == ADD || aluc == SUB) && (sa[31] == sb[31]) && (res[31] != sa[31])) ? 1'b1 : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'b0;

endmodule