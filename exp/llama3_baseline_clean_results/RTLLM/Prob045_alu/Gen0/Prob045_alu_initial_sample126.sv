module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
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

reg [31:0] res;
reg         z;
reg         c;
reg         n;
reg         o;
reg         f;

assign r = res;
assign zero = z;
assign carry = c;
assign negative = n;
assign overflow = o;
assign flag = f;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            {c, res} = a + b;
            z = (res == 0);
            n = res[31];
            o = (a[31] == b[31] && b[31] != res[31]);
            f = 1'bz;
        end
        ADDU: begin
            {c, res} = a + b;
            z = (res == 0);
            n = res[31];
            o = 1'b0;
            f = 1'bz;
        end
        SUB: begin
            {c, res} = a - b;
            z = (res == 0);
            n = res[31];
            o = (a[31] != b[31] && b[31] == res[31]);
            f = 1'bz;
        end
        SUBU: begin
            {c, res} = a - b;
            z = (res == 0);
            n = res[31];
            o = 1'b0;
            f = 1'bz;
        end
        AND: begin
            res = a & b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        OR: begin
            res = a | b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        XOR: begin
            res = a ^ b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        NOR: begin
            res = ~(a | b);
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SLT: begin
            res = (a < b) ? 32'b1 : 32'b0;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = (a < b);
        end
        SLTU: begin
            res = ({32'b0} + a < {32'b0} + b) ? 32'b1 : 32'b0;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = ({32'b0} + a < {32'b0} + b);
        end
        SLL: begin
            res = a << b[4:0];
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SRL: begin
            res = a >> b[4:0];
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SRA: begin
            res = $signed(a) >>> b[4:0];
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SLLV: begin
            res = a << b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SRLV: begin
            res = a >> b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        SRAV: begin
            res = $signed(a) >>> b;
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        LUI: begin
            res = {b[15:0], 16'b0};
            z = (res == 0);
            n = res[31];
            c = 1'b0;
            o = 1'b0;
            f = 1'bz;
        end
        default: begin
            res = 32'bz;
            z = 1'bx;
            n = 1'bx;
            c = 1'bx;
            o = 1'bx;
            f = 1'bx;
        end
    endcase
end

endmodule