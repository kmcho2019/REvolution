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
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

reg [31:0] res;
reg c, ov, n, z, f;

always @(a, b, aluc) begin
    case (aluc)
        ADD, ADDU: begin
            {c, res} = a + b;
            ov = (a[31] == b[31] && a[31] != res[31]);
        end
        SUB, SUBU: begin
            {c, res} = a - b;
            ov = (a[31] != b[31] && a[31] != res[31]);
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT, SLTU: begin
            if (aluc == SLT)
                res = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
            else
                res = (a < b) ? 32'h1 : 32'h0;
            f = 1'b1;
        end
        SLL, SRL, SRA: begin
            if (aluc == SLL)
                res = a << b[4:0];
            else if (aluc == SRL)
                res = a >> b[4:0];
            else
                res = a >>> b[4:0];
        end
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'bz;
    endcase
    r = res;
    zero = (res == 32'h0);
    carry = c;
    negative = res[31];
    overflow = ov;
    flag = f;
end

endmodule