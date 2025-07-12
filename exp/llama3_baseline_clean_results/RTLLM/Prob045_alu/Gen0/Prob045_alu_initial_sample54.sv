module alu (
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

    reg signed [31:0] sa, sb;
    reg [31:0] res;
    reg [31:0] temp;

    assign sa = a;
    assign sb = b;
    assign r = res[31:0];

    always @(*) begin
        res = 32'bz;
        flag = 1'bz;
        zero = 1'bz;
        carry = 1'bz;
        negative = 1'bz;
        overflow = 1'bz;

        case (aluc)
            ADD: begin
                {carry, res} = sa + sb;
                zero = (res == 32'b0);
                negative = res[31];
                overflow = (sa[31] == sb[31] && sa[31] != res[31]);
            end

            ADDU: begin
                {carry, res} = a + b;
                zero = (res == 32'b0);
                negative = res[31];
            end

            SUB: begin
                {carry, res} = sa - sb;
                zero = (res == 32'b0);
                negative = res[31];
                overflow = (sa[31] != sb[31] && sa[31] != res[31]);
            end

            SUBU: begin
                {carry, res} = a - b;
                zero = (res == 32'b0);
                negative = res[31];
            end

            AND: begin
                res = a & b;
                zero = (res == 32'b0);
                negative = res[31];
            end

            OR: begin
                res = a | b;
                zero = (res == 32'b0);
                negative = res[31];
            end

            XOR: begin
                res = a ^ b;
                zero = (res == 32'b0);
                negative = res[31];
            end

            NOR: begin
                res = ~(a | b);
                zero = (res == 32'b0);
                negative = res[31];
            end

            SLT: begin
                res = (sa < sb) ? 32'b1 : 32'b0;
                flag = (sa < sb);
                zero = (res == 32'b0);
                negative = res[31];
            end

            SLTU: begin
                res = (a < b) ? 32'b1 : 32'b0;
                flag = (a < b);
                zero = (res == 32'b0);
                negative = res[31];
            end

            SLL: begin
                res = a << b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            SRL: begin
                res = a >> b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            SRA: begin
                res = sa >>> b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            SLLV: begin
                res = a << b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            SRLV: begin
                res = a >> b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            SRAV: begin
                res = sa >>> b[4:0];
                zero = (res == 32'b0);
                negative = res[31];
            end

            LUI: begin
                res = {b[15:0], 16'b0};
                zero = (res == 32'b0);
                negative = res[31];
            end

            default: begin
                res = 32'bz;
                flag = 1'bz;
                zero = 1'bz;
                carry = 1'bz;
                negative = 1'bz;
                overflow = 1'bz;
            end
        endcase
    end
endmodule