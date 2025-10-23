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

// Operation categories
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

// Output flags
reg [31:0] res;
always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            carry = (a[31] != b[31]) && (a[31] != res[31]);
            overflow = (a[31] == b[31]) && (a[31] != res[31]);
            flag = 1'b0;
        end
        SUB: begin
            res = a - b;
            carry = (a[31] == b[31]) && (a[31] != res[31]);
            overflow = (a[31] != b[31]) && (a[31] == res[31]);
            flag = 1'b0;
        end
        ADDU: begin
            res = a + b;
            carry = (res[31] == 1'b1) && (a[31] != res[31]);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUBU: begin
            res = a - b;
            carry = (res[31] == 1'b0) && (a[31] != res[31]);
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            res = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            res = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLL: begin
            res = a << (b[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            res = a >> (b[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            res = a >>> (b[4:0]);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            res = a << b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            res = a >> b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            res = a >>> b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            res = {b[15:0], 16'd0};
            flag = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            res = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
    zero = (res == 32'd0);
    negative = (res[31] == 1'b1);
end

assign r = res;

endmodule