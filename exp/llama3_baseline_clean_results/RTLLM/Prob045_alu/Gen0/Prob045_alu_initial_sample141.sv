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

wire signed [31:0] sa = a;
wire signed [31:0] sb = b;

always @(*) begin
    case (aluc)
        ADD: begin
            r = a + b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            negative = r[31];
            overflow = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        ADDU: begin
            r = a + b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            r = a - b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            negative = r[31];
            overflow = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        SUBU: begin
            r = a - b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == b[31] && a[31] != r[31]) ? 1'b1 : 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = a & b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = a | b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = sa < sb ? 32'd1 : 32'd0;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = (sa < sb) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = a < b ? 32'd1 : 32'd0;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = a << b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = a >> b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = sa >>> b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = a << a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = a >> a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = sa >>> a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = { a[15:0], 16'd0 };
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = r[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: begin
            r = 'z;
            zero = 'z;
            carry = 'z;
            negative = 'z;
            overflow = 'z;
            flag = 'z;
        end
    endcase
end

endmodule