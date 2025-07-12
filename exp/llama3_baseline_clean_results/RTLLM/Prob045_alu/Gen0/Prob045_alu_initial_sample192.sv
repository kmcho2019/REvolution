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

always @(a or b or aluc) begin
    case (aluc)
        ADD: begin
            {c, res} = a + b;
            o = (a[31] == b[31] && a[31] != res[31]);
        end
        ADDU: begin
            {c, res} = a + b;
            o = 0;
        end
        SUB: begin
            {c, res} = a - b;
            o = (a[31] != b[31] && a[31] == res[31]);
        end
        SUBU: begin
            {c, res} = a - b;
            o = 0;
        end
        AND: begin
            res = a & b;
            c = 0;
            o = 0;
        end
        OR: begin
            res = a | b;
            c = 0;
            o = 0;
        end
        XOR: begin
            res = a ^ b;
            c = 0;
            o = 0;
        end
        NOR: begin
            res = ~(a | b);
            c = 0;
            o = 0;
        end
        SLT: begin
            res = (a < b) ? 32'd1 : 32'd0;
            c = 0;
            o = 0;
            f = (a < b);
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            c = 0;
            o = 0;
            f = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
            c = 0;
            o = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            c = 0;
            o = 0;
        end
        SRA: begin
            res = a >>> b[4:0];
            c = 0;
            o = 0;
        end
        SLLV: begin
            res = a << b;
            c = 0;
            o = 0;
        end
        SRLV: begin
            res = a >> b;
            c = 0;
            o = 0;
        end
        SRAV: begin
            res = a >>> b;
            c = 0;
            o = 0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            c = 0;
            o = 0;
        end
        default: begin
            res = 32'bx;
            c = 1'bx;
            o = 1'bx;
            f = 1'bx;
        end
    endcase
    z = (res == 32'd0);
    n = res[31];
end

assign r = res;
assign zero = z;
assign carry = c;
assign negative = n;
assign flag = (aluc == SLT || aluc == SLTU) ? f : 1'bz;
assign overflow = o;

endmodule