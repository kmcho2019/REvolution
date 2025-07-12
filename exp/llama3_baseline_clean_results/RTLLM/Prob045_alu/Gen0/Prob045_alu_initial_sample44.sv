`timescale 1ns/1ps

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
reg        res_zero;
reg        res_carry;
reg        res_negative;
reg        res_overflow;
reg        res_flag;

always @(*) begin
    case (aluc)
        ADD: begin
            {res_carry, res} = a + b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_overflow = (a[31] == b[31] && a[31]!= res[31]);
            res_flag = 1'b0;
        end
        ADDU: begin
            {res_carry, res} = a + b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SUB: begin
            {res_carry, res} = a - b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_overflow = (a[31]!= b[31] && a[31]!= res[31]);
            res_flag = 1'b0;
        end
        SUBU: begin
            {res_carry, res} = a - b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        AND: begin
            res = a & b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        OR: begin
            res = a | b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SLT: begin
            res = (a < b)? 32'd1 : 32'd0;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = (a < b);
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SRA: begin
            res = a >>> b[4:0];
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SLLV: begin
            res = a << b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SRLV: begin
            res = a >> b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        SRAV: begin
            res = a >>> b;
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            res_zero = (res == 32'd0);
            res_negative = res[31];
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
        default: begin
            res = 32'd0;
            res_zero = 1'b0;
            res_negative = 1'b0;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
    endcase
end

assign r = res;
assign zero = res_zero;
assign carry = res_carry;
assign negative = res_negative;
assign overflow = res_overflow;
assign flag = res_flag;

endmodule