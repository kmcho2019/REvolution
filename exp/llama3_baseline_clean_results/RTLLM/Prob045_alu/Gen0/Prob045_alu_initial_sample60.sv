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

wire [31:0] a_signed = a;
wire [31:0] b_signed = b;
wire [31:0] a_unsigned = a;
wire [31:0] b_unsigned = b;

assign r = res;
assign zero = (res == 32'b0) ? 1'b1 : 1'b0;
assign negative = res[31] ? 1'b1 : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? (a_signed < b_signed) : 1'bz;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, res} = a_signed + b_signed;
            overflow = (a_signed[31] == b_signed[31] && a_signed[31] != res[31]) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            {carry, res} = a_unsigned + b_unsigned;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, res} = a_signed - b_signed;
            overflow = (a_signed[31] != b_signed[31] && a_signed[31] != res[31]) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            {carry, res} = a_unsigned - b_unsigned;
            overflow = 1'b0;
        end
        AND: begin
            res = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            res = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            res = (a_signed < b_signed) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            res = (a_unsigned < b_unsigned) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            res = a_signed >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            res = a << b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            res = a >> b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            res = a_signed >>> b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            res = 32'bz;
            carry = 1'bz;
            overflow = 1'bz;
        end
    endcase
end

endmodule