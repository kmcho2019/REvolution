module alu (
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

    wire signed [31:0] a_signed;
    wire signed [31:0] b_signed;
    reg [31:0] res;
    reg zero_reg;
    reg carry_reg;
    reg negative_reg;
    reg overflow_reg;
    reg flag_reg;

    assign a_signed = a;
    assign b_signed = b;
    assign r = res;
    assign zero = zero_reg;
    assign carry = carry_reg;
    assign negative = negative_reg;
    assign overflow = overflow_reg;
    assign flag = flag_reg;

    always @(*) begin
        case (aluc)
            ADD: begin
                res = a + b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                if (a[31] == b[31] && res[31] != a[31]) overflow_reg = 1'b1;
                else overflow_reg = 1'b0;
                negative_reg = res[31];
            end
            ADDU: begin
                res = a + b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                if (a[31] == b[31] && res[31] != a[31]) overflow_reg = 1'b1;
                else overflow_reg = 1'b0;
                negative_reg = res[31];
            end
            SUB: begin
                res = a - b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                if (a[31] != b[31] && res[31] == a[31]) overflow_reg = 1'b1;
                else overflow_reg = 1'b0;
                negative_reg = res[31];
            end
            SUBU: begin
                res = a - b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                if (a[31] != b[31] && res[31] == a[31]) overflow_reg = 1'b1;
                else overflow_reg = 1'b0;
                negative_reg = res[31];
            end
            AND: begin
                res = a & b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            OR: begin
                res = a | b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            XOR: begin
                res = a ^ b;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            NOR: begin
                res = ~(a | b);
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SLT: begin
                if (a_signed < b_signed) res = 32'd1;
                else res = 32'd0;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
                flag_reg = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;
            end
            SLTU: begin
                if (a < b) res = 32'd1;
                else res = 32'd0;
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
                flag_reg = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;
            end
            SLL: begin
                res = a << b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SRL: begin
                res = a >> b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SRA: begin
                res = a_signed >>> b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SLLV: begin
                res = a << b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SRLV: begin
                res = a >> b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            SRAV: begin
                res = a_signed >>> b[4:0];
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            LUI: begin
                res = {a[15:0], 16'd0};
                if (res == 32'd0) zero_reg = 1'b1;
                else zero_reg = 1'b0;
                negative_reg = res[31];
            end
            default: begin
                res = 32'bz;
                zero_reg = 1'bz;
                carry_reg = 1'bz;
                negative_reg = 1'bz;
                overflow_reg = 1'bz;
                flag_reg = 1'bz;
            end
        endcase
    end

endmodule