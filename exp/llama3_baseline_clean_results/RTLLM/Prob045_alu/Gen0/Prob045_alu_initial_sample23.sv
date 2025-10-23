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
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

always @(a, b, aluc) begin
    case(aluc)
        ADD: begin
            res = a + b;
            carry_reg = (a[31] == b[31]) && (res[31] != a[31]);
            overflow_reg = (a[31] == b[31]) && (res[31] != a[31]);
        end
        ADDU: begin
            res = a + b;
            carry_reg = (a + b > 32'd4294967295);
            overflow_reg = 1'b0;
        end
        SUB: begin
            res = a - b;
            carry_reg = (a[31] != b[31]) && (res[31] == a[31]);
            overflow_reg = (a[31] != b[31]) && (res[31] == a[31]);
        end
        SUBU: begin
            res = a - b;
            carry_reg = (a < b);
            overflow_reg = 1'b0;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag_reg = (signed'(a) < signed'(b));
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag_reg = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
        end
        SRL: begin
            res = a >> b[4:0];
        end
        SRA: begin
            res = signed'(a) >>> b[4:0];
        end
        SLLV: begin
            res = a << b;
        end
        SRLV: begin
            res = a >> b;
        end
        SRAV: begin
            res = signed'(a) >>> b;
        end
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'bz;
    endcase

    zero_reg = (res == 32'd0);
    negative_reg = res[31];
    r = res;
    zero = zero_reg;
    carry = carry_reg;
    negative = negative_reg;
    overflow = overflow_reg;
    flag = (aluc == SLT || aluc == SLTU) ? flag_reg : 1'bz;
end

endmodule