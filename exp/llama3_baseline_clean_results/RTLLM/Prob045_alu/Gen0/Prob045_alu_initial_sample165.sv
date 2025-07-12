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
    reg zero_r, carry_r, negative_r, overflow_r, flag_r;

    always @(a or b or aluc) begin
        case (aluc)
            ADD: begin
                res = a + b;
                carry_r = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1);
                overflow_r = (a[31] == b[31] && b[31] != res[31]);
            end

            ADDU: begin
                res = a + b;
                carry_r = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0);
                overflow_r = 1'b0;
            end

            SUB: begin
                res = a - b;
                carry_r = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1) || (a[31] == 1'b1 && b[31] == 1'b0 && res[31] == 1'b0);
                overflow_r = (a[31] != b[31] && b[31] == res[31]);
            end

            SUBU: begin
                res = a - b;
                carry_r = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1);
                overflow_r = 1'b0;
            end

            AND: begin
                res = a & b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            OR: begin
                res = a | b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            XOR: begin
                res = a ^ b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            NOR: begin
                res = ~(a | b);
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SLT: begin
                res = (a < b) ? 32'd1 : 32'd0;
                flag_r = (a < b) ? 1'b1 : 1'b0;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SLTU: begin
                res = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
                flag_r = ($unsigned(a) < $unsigned(b)) ? 1'b1 : 1'b0;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SLL: begin
                res = a << b[4:0];
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SRL: begin
                res = a >> b[4:0];
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SRA: begin
                res = a >>> b[4:0];
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SLLV: begin
                res = a << b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SRLV: begin
                res = a >> b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            SRAV: begin
                res = a >>> b;
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            LUI: begin
                res = {a[15:0], 16'd0};
                carry_r = 1'b0;
                overflow_r = 1'b0;
            end

            default: begin
                res = 32'bz;
                carry_r = 1'bz;
                overflow_r = 1'bz;
            end
        endcase

        zero_r = (res == 32'd0) ? 1'b1 : 1'b0;
        negative_r = res[31];
        flag_r = (aluc == SLT || aluc == SLTU) ? flag_r : 1'bz;
    end

    assign r = res;
    assign zero = zero_r;
    assign carry = carry_r;
    assign negative = negative_r;
    assign overflow = overflow_r;
    assign flag = flag_r;

endmodule