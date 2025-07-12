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

reg signed [31:0] a_signed;
reg unsigned [31:0] a_unsigned;
reg signed [31:0] b_signed;
reg unsigned [31:0] b_unsigned;

assign a_signed = a;
assign a_unsigned = a;
assign b_signed = b;
assign b_unsigned = b;

always @(*) begin
    case(aluc)
        ADD: begin
            {carry, r} = a_signed + b_signed;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = ((a_signed[31] == b_signed[31]) && (a_signed[31] != r[31]));
            flag = 1'b0;
        end
        ADDU: begin
            {carry, r} = a_unsigned + b_unsigned;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            {carry, r} = a_signed - b_signed;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = ((a_signed[31] == b_signed[31]) && (a_signed[31] != r[31]));
            flag = 1'b0;
        end
        SUBU: begin
            {carry, r} = a_unsigned - b_unsigned;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = a & b;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = a | b;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = (a_signed < b_signed) ? 32'd1 : 32'd0;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = (a_signed < b_signed);
        end
        SLTU: begin
            r = (a_unsigned < b_unsigned) ? 32'd1 : 32'd0;
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = (a_unsigned < b_unsigned);
        end
        SLL: begin
            r = a << a[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = a >> a[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = a_signed >>> a[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = a << b[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = a >> b[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = a_signed >>> b[4:0];
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = {a[15:0], 16'd0};
            zero = (r == 0);
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'b0;
        end
        default: begin
            r = 32'bz;
            zero = 1'bz;
            negative = 1'bz;
            overflow = 1'bz;
            carry = 1'bz;
            flag = 1'bz;
        end
    endcase
end

endmodule