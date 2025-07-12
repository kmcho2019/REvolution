module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0] aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
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

wire [31:0] res;
wire [31:0] a_signed, b_signed;
assign a_signed = a;
assign b_signed = b;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            res = a + b;
            zero = (res == 32'b0);
            carry = (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1);
            negative = (res[31] == 1'b1);
            overflow = (a[31] == b[31] && b[31] != res[31]);
            flag = 1'b0;
        end
        ADDU: begin
            res = a + b;
            zero = (res == 32'b0);
            carry = (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1);
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            res = a - b;
            zero = (res == 32'b0);
            carry = (a[31] == 1'b1 && b[31] == 1'b0 && res[31] == 1'b0);
            negative = (res[31] == 1'b1);
            overflow = (a[31] != b[31] && b[31] == res[31]);
            flag = 1'b0;
        end
        SUBU: begin
            res = a - b;
            zero = (res == 32'b0);
            carry = (a[31] == 1'b1 && b[31] == 1'b0 && res[31] == 1'b0);
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            res = a & b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            res = a | b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            res = (signed'(a_signed) < signed'(b_signed)) ? 32'b1 : 32'b0;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = (res == 32'b1);
        end
        SLTU: begin
            res = (a < b) ? 32'b1 : 32'b0;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = (res == 32'b1);
        end
        SLL: begin
            res = a << b[4:0];
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            res = a_signed >>> b[4:0];
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            res = a << b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            res = a >> b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            res = a_signed >>> b;
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            res = {b[15:0], 16'b0};
            zero = (res == 32'b0);
            carry = 1'b0;
            negative = (res[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: begin
            res = 32'bz;
            zero = 1'bx;
            carry = 1'bx;
            negative = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
    assign r = res;
end

endmodule