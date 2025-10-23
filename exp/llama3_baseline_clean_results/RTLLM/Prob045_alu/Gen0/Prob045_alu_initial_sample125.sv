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
reg z, c, n, o, f;

always @(*) begin
    case (aluc)
        ADD: begin
            {c, res} = a + b;
            z = (res == 32'd0);
            n = res[31];
            o = (a[31] == b[31] && a[31] != res[31]);
            f = 1'b0;
        end
        ADDU: begin
            {c, res} = a + b;
            z = (res == 32'd0);
            n = res[31];
            o = 1'b0;
            f = 1'b0;
        end
        SUB: begin
            {c, res} = a - b;
            z = (res == 32'd0);
            n = res[31];
            o = (a[31] != b[31] && a[31] != res[31]);
            f = 1'b0;
        end
        SUBU: begin
            {c, res} = a - b;
            z = (res == 32'd0);
            n = res[31];
            o = 1'b0;
            f = 1'b0;
        end
        AND: begin
            res = a & b;
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        OR: begin
            res = a | b;
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SLT: begin
            f = (signed'(a) < signed'(b));
            res = {31'd0, f};
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
        end
        SLTU: begin
            f = (a < b);
            res = {31'd0, f};
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SRA: begin
            res = a >>> b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SLLV: begin
            res = a << b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SRLV: begin
            res = a >> b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        SRAV: begin
            res = a >>> b[4:0];
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        LUI: begin
            res = {b[15:0], 16'd0};
            z = (res == 32'd0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
        default: begin
            res = 32'd0;
            z = 1'b0;
            n = 1'b0;
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
    endcase
    r = res;
    zero = z;
    carry = c;
    negative = n;
    overflow = o;
    flag = f;
end

endmodule