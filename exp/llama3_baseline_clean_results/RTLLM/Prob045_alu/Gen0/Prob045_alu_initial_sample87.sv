module alu(
    input wire [31:0] a, 
    input wire [31:0] b, 
    input wire [5:0] aluc, 
    output wire [31:0] r, 
    output wire zero, 
    output wire carry, 
    output wire negative, 
    output wire overflow, 
    output wire flag
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
    res = 32'bx;
    case(aluc)
        ADD: begin
            {c, res} = a + b;
            z = (res == 32'b0);
            n = res[31];
            o = (a[31] == b[31] && b[31] != res[31]);
            f = 1'bx;
        end
        ADDU: begin
            {c, res} = a + b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            f = 1'bx;
        end
        SUB: begin
            {c, res} = a - b;
            z = (res == 32'b0);
            n = res[31];
            o = (a[31] != b[31] && b[31] == res[31]);
            f = 1'bx;
        end
        SUBU: begin
            {c, res} = a - b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            f = 1'bx;
        end
        AND: begin
            res = a & b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        OR: begin
            res = a | b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        XOR: begin
            res = a ^ b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        NOR: begin
            res = ~(a | b);
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SLT: begin
            res = (a < b) ? 32'b1 : 32'b0;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = (a < b);
        end
        SLTU: begin
            res = ({32{1'b0}} + a < {32{1'b0}} + b) ? 32'b1 : 32'b0;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = ({32{1'b0}} + a < {32{1'b0}} + b);
        end
        SLL: begin
            res = a << b[4:0];
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SRL: begin
            res = a >> b[4:0];
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SRA: begin
            res = {{32{a[31]}}, a} >> b[4:0];
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SLLV: begin
            res = a << b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SRLV: begin
            res = a >> b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        SRAV: begin
            res = {{32{a[31]}}, a} >> b;
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            z = (res == 32'b0);
            n = res[31];
            o = 1'b0;
            c = 1'b0;
            f = 1'bx;
        end
        default: begin
            res = 32'bx;
            z = 1'bx;
            n = 1'bx;
            o = 1'bx;
            c = 1'bx;
            f = 1'bx;
        end
    endcase
end

assign r = res;
assign zero = z;
assign carry = c;
assign negative = n;
assign overflow = o;
assign flag = f;

endmodule