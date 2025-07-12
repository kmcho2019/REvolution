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
reg z;
reg c;
reg n;
reg v;
reg f;

always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            z = (res == 0);
            c = (a + b > 32'hffffffff);
            n = (res[31] == 1);
            v = (a[31] == b[31] && a[31] != res[31]);
            f = 0;
        end
        ADDU: begin
            res = a + b;
            z = (res == 0);
            c = (a + b > 32'hffffffff);
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SUB: begin
            res = a - b;
            z = (res == 0);
            c = (a < b);
            n = (res[31] == 1);
            v = (a[31] != b[31] && a[31] != res[31]);
            f = 0;
        end
        SUBU: begin
            res = a - b;
            z = (res == 0);
            c = (a < b);
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        AND: begin
            res = a & b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        OR: begin
            res = a | b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        XOR: begin
            res = a ^ b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        NOR: begin
            res = ~(a | b);
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SLT: begin
            res = (a < b) ? 1 : 0;
            z = (res == 0);
            c = 0;
            n = (res == 1);
            v = 0;
            f = (a < b);
        end
        SLTU: begin
            res = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
            z = (res == 0);
            c = 0;
            n = (res == 1);
            v = 0;
            f = ($unsigned(a) < $unsigned(b));
        end
        SLL: begin
            res = a << b[4:0];
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SRA: begin
            res = $signed(a) >>> b[4:0];
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SLLV: begin
            res = a << b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SRLV: begin
            res = a >> b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        SRAV: begin
            res = $signed(a) >>> b;
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            z = (res == 0);
            c = 0;
            n = (res[31] == 1);
            v = 0;
            f = 0;
        end
        default: begin
            res = 32'bz;
            z = 0;
            c = 0;
            n = 0;
            v = 0;
            f = 0;
        end
    endcase
end

assign r = res;
assign zero = z;
assign carry = c;
assign negative = n;
assign overflow = v;
assign flag = f;

endmodule