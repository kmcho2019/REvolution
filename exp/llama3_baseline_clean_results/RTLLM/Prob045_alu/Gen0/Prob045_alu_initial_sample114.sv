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
        case(aluc)
            ADD: 
            begin
                res = a + b;
                carry_reg = 0;
                overflow_reg = (a[31] == b[31] && a[31] != res[31]) ? 1 : 0;
            end

            ADDU: 
            begin
                res = a + b;
                carry_reg = (a[31] + b[31] > 1) ? 1 : 0;
                overflow_reg = 0;
            end

            SUB: 
            begin
                res = a - b;
                carry_reg = 0;
                overflow_reg = (a[31] != b[31] && a[31] != res[31]) ? 1 : 0;
            end

            SUBU: 
            begin
                res = a - b;
                carry_reg = (a[31] < b[31]) ? 1 : 0;
                overflow_reg = 0;
            end

            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);

            SLT: 
            begin
                res = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
                flag_reg = (signed'(a) < signed'(b)) ? 1 : 0;
            end

            SLTU: 
            begin
                res = (a < b) ? 32'h1 : 32'h0;
                flag_reg = (a < b) ? 1 : 0;
            end

            SLL: 
            begin
                res = a << b[4:0];
                carry_reg = (a[(32-b[4:0])-1:0] != 0) ? 1 : 0;
            end

            SRL: 
            begin
                res = a >> b[4:0];
                carry_reg = (a[b[4:0]:0] != 0) ? 1 : 0;
            end

            SRA: 
            begin
                res = a >>> b[4:0];
                carry_reg = (a[b[4:0]:0] != 0) ? 1 : 0;
            end

            SLLV: 
            begin
                res = a << b[4:0];
                carry_reg = (a[(32-b[4:0])-1:0] != 0) ? 1 : 0;
            end

            SRLV: 
            begin
                res = a >> b[4:0];
                carry_reg = (a[b[4:0]:0] != 0) ? 1 : 0;
            end

            SRAV: 
            begin
                res = a >>> b[4:0];
                carry_reg = (a[b[4:0]:0] != 0) ? 1 : 0;
            end

            LUI: res = {b[15:0], 16'b0};

            default: 
            begin
                res = 32'bz;
                carry_reg = 1'bz;
                overflow_reg = 1'bz;
                flag_reg = 1'bz;
            end
        endcase

        r = res;
        zero = (res == 32'h0) ? 1 : 0;
        carry = carry_reg;
        negative = res[31] ? 1 : 0;
        overflow = overflow_reg;
        flag = flag_reg;
    end

endmodule