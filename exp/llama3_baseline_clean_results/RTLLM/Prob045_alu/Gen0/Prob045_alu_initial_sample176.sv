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

always @(a or b or aluc) begin
    case (aluc)
        ADD: begin
            res = a + b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (a[31] == b[31] && res[31] != a[31]) overflow = 1'b1;
            else overflow = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            if (res > 32'd0) carry = 1'b1;
            else carry = 1'b0;
            flag = 1'bz;
        end
        ADDU: begin
            res = a + b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SUB: begin
            res = a - b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (a[31] == b[31] && res[31] != a[31]) overflow = 1'b1;
            else overflow = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SUBU: begin
            res = a - b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        AND: begin
            res = a & b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        OR: begin
            res = a | b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        XOR: begin
            res = a ^ b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        NOR: begin
            res = ~(a | b);
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLT: begin
            if ($signed(a) < $signed(b)) begin
                res = 32'd1;
                flag = 1'b1;
            end else begin
                res = 32'd0;
                flag = 1'b0;
            end
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            if (a < b) begin
                res = 32'd1;
                flag = 1'b1;
            end else begin
                res = 32'd0;
                flag = 1'b0;
            end
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRL: begin
            res = a >> b[4:0];
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRA: begin
            res = a >>> b[4:0];
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLLV: begin
            res = a << b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRLV: begin
            res = a >> b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRAV: begin
            res = a >>> b;
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            if (res == 0) zero = 1'b1;
            else zero = 1'b0;
            if (res[31] == 1'b1) negative = 1'b1;
            else negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        default: begin
            res = 32'bz;
            zero = 1'bz;
            negative = 1'bz;
            carry = 1'bz;
            overflow = 1'bz;
            flag = 1'bz;
        end
    endcase
end

assign r = res;

endmodule