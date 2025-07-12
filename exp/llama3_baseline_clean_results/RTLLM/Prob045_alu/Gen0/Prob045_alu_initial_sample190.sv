module alu(
    input   wire [31:0]  a,
    input   wire [31:0]  b,
    input   wire [5:0]   aluc,
    output  reg  [31:0]  r,
    output  reg          zero,
    output  reg          carry,
    output  reg          negative,
    output  reg          overflow,
    output  reg          flag
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

reg [31:0] signed_a;
reg [31:0] signed_b;

always @(*) begin
    signed_a = a;
    signed_b = b;

    case (aluc)
        ADD: begin
            r = signed_a + signed_b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = ((signed_a[31] == signed_b[31]) && (r[31] != signed_a[31])) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        ADDU: begin
            r = a + b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a + b > 32'hffffffff) ? 1'b1 : 1'b0;
            negative = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            r = signed_a - signed_b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = ((signed_a[31] != signed_b[31]) && (r[31] != signed_a[31])) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        SUBU: begin
            r = a - b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a < b) ? 1'b1 : 1'b0;
            negative = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = a & b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = a | b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = (signed_a < signed_b) ? 32'h1 : 32'h0;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'h1 : 32'h0;
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = a << a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == 1'b1 && a[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = a >> a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[0] == 1'b1 && a[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = signed_a >>> a[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (signed_a[0] == 1'b1 && a[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = a << b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[31] == 1'b1 && b[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = a >> b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (a[0] == 1'b1 && b[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = signed_a >>> b[4:0];
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = (signed_a[0] == 1'b1 && b[4:0] != 0) ? 1'b1 : 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = {a[15:0], 16'b0};
            zero = (r == 0) ? 1'b1 : 1'b0;
            carry = 1'b0;
            negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: begin
            r = 32'bx;
            zero = 1'bx;
            carry = 1'bx;
            negative = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end
endmodule