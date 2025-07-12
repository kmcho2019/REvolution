module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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
parameter LUI = 6'b001111;

reg [32:0] res;

always @(a, b, aluc) begin
    case (aluc)
        ADD, ADDU: begin
            res = a + b;
            flag = 1'b0;
        end
        SUB, SUBU: begin
            res = a - b;
            flag = 1'b0;
        end
        AND: res = {1'b0, a & b};
        OR: res = {1'b0, a | b};
        XOR: res = {1'b0, a ^ b};
        NOR: res = {1'b0, ~(a | b)};
        SLT: begin
            res = {$signed(a) < $signed(b)} ? 33'd1 : 33'd0;
            flag = 1'b1;
        end
        SLTU: begin
            res = {1'b0, a < b} ? 33'd1 : 33'd0;
            flag = 1'b1;
        end
        SLL: res = {1'b0, a << b[4:0]};
        SRL: res = {1'b0, a >> b[4:0]};
        SRA: res = {1'b0, $signed(a) >>> b[4:0]};
        LUI: res = {a[15:0], 16'd0};
        default: res = 33'bz;
    endcase
    r = res[31:0];
    zero = (r == 32'd0);
    carry = res[32];
    negative = r[31];
    overflow = (aluc == ADD || aluc == SUB) && $signed(a[31]) == $signed(b[31]) && $signed(r[31]) != $signed(a[31]);
    flag = (aluc == SLT || aluc == SLTU) && res[0];
end

endmodule