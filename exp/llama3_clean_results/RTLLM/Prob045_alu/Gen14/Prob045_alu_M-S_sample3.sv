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
parameter SUB = 6'b100010;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter LUI = 6'b001111;

reg [31:0] res;
reg c, ov, n, z, f;

always @(a, b, aluc) begin
    case (aluc)
        ADD, SUB: begin
            if (aluc == ADD) {c, res} = a + b;
            else {c, res} = a - b;
            ov = (a[31] != res[31]) && ((a[31] == b[31]) != (aluc == ADD));
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            if (signed'(a) < signed'(b)) res = 32'h1;
            else res = 32'h0;
            f = 1'b1;
        end
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
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