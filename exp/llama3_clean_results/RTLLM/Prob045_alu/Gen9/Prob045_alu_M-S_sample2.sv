module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
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

always @(*) begin
    case (aluc)
        ADD: begin
            r = a + b;
            zero = (r == 0);
            carry = (a[31] == b[31] && a[31] != r[31]);
            negative = r[31];
            overflow = (a[31] == b[31] && a[31] != r[31]);
            flag = 0;
        end
        ADDU: begin
            r = a + b;
            zero = (r == 0);
            carry = (a[31] == b[31] && a[31] != r[31]);
            negative = r[31];
            overflow = (a[31] == b[31] && a[31] != r[31]);
            flag = 0;
        end
        SUB: begin
            r = a - b;
            zero = (r == 0);
            carry = (a[31] != b[31] && a[31] == r[31]);
            negative = r[31];
            overflow = (a[31] != b[31] && a[31] == r[31]);
            flag = 0;
        end
        SUBU: begin
            r = a - b;
            zero = (r == 0);
            carry = (a[31] != b[31] && a[31] == r[31]);
            negative = r[31];
            overflow = (a[31] != b[31] && a[31] == r[31]);
            flag = 0;
        end
        AND: begin
            r = a & b;
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        OR: begin
            r = a | b;
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        XOR: begin
            r = a ^ b;
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        NOR: begin
            r = ~(a | b);
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        SLT: begin
            r = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            r = (a < b)? 32'd1 : 32'd0;
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = (a < b);
        end
        SLL: begin
            r = a << b[4:0];
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        SRL: begin
            r = a >> b[4:0];
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        SRA: begin
            r = a >>> b[4:0];
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        LUI: begin
            r = {b[15:0], 16'd0};
            zero = (r == 0);
            carry = 0;
            negative = r[31];
            overflow = 0;
            flag = 0;
        end
        default: begin
            r = 32'd0;
            zero = 1;
            carry = 0;
            negative = 0;
            overflow = 0;
            flag = 0;
        end
    endcase
end

endmodule