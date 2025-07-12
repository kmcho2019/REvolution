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
reg zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

always @(*)
begin
    case (aluc)
        ADD:
        begin
            res = a + b;
            carry_reg = (a[31] == b[31] && (a[31] != res[31]));
            overflow_reg = (a[31] == b[31] && (a[31] != res[31]));
            negative_reg = res[31];
        end
        ADDU:
        begin
            res = a + b;
            carry_reg = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0);
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SUB:
        begin
            res = a - b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1);
            overflow_reg = (a[31] == b[31] && (a[31] != res[31]));
            negative_reg = res[31];
        end
        SUBU:
        begin
            res = a - b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1);
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        AND:
        begin
            res = a & b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        OR:
        begin
            res = a | b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        XOR:
        begin
            res = a ^ b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        NOR:
        begin
            res = ~(a | b);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SLT:
        begin
            res = (signed'(a) < signed'(b)) ? 32'b1 : 32'b0;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SLTU:
        begin
            res = (unsigned'(a) < unsigned'(b)) ? 32'b1 : 32'b0;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SLL:
        begin
            res = a << b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SRL:
        begin
            res = a >> b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SRA:
        begin
            res = signed'(a) >>> b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SLLV:
        begin
            res = a << b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SRLV:
        begin
            res = a >> b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        SRAV:
        begin
            res = signed'(a) >>> b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        LUI:
        begin
            res = {a[15:0], 16'b0};
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
        end
        default:
        begin
            res = 32'bz;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = 1'b0;
        end
    endcase

    zero_reg = (res == 32'b0);
    flag_reg = (aluc == SLT || aluc == SLTU);
    r = res;
    zero = zero_reg;
    carry = carry_reg;
    negative = negative_reg;
    overflow = overflow_reg;
    flag = flag_reg;
end

endmodule