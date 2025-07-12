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
reg zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

always @(*) begin
    case (aluc)
        ADD: res = a + b;
        ADDU: res = a + b;
        SUB: res = a - b;
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (a < b) ? 1 : 0;
        SLTU: res = (a < b) ? 1 : 0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = a >>> a[4:0];
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'bz;
    endcase

    zero_reg = (res == 0) ? 1'b1 : 1'b0;
    carry_reg = (aluc == ADD || aluc == ADDU) ? (a + b > 32'hffffffff) : 1'b0;
    negative_reg = (res[31] == 1'b1) ? 1'b1 : 1'b0;
    overflow_reg = ((aluc == ADD || aluc == SUB) && ((a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1))) ? 1'b1 : 1'b0;
    flag_reg = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;

    r = res;
    zero = zero_reg;
    carry = carry_reg;
    negative = negative_reg;
    overflow = overflow_reg;
    flag = flag_reg;
end

endmodule