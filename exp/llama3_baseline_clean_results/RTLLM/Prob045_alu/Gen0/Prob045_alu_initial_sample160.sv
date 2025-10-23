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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    assign zero = (res == 32'd0);
    assign negative = res[31];
    assign overflow = ((a[31] == b[31]) && (a[31] != res[31])) || ((aluc == ADD || aluc == SUB) && (a[31] != b[31]));

    always @(a or b or aluc) begin
        case(aluc)
            ADD: res = a + b;
            ADDU: res = a + b;
            SUB: res = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a_signed < b_signed) ? 32'd1 : 32'd0;
            SLTU: res = (a < b) ? 32'd1 : 32'd0;
            SLL: res = a << b[4:0];
            SRL: res = a >> b[4:0];
            SRA: res = a_signed >>> b[4:0];
            SLLV: res = a << b;
            SRLV: res = a >> b;
            SRAV: res = a_signed >>> b;
            LUI: res = { a[15:0], 16'd0 };
            default: res = 32'd0;
        endcase
    end

    assign carry = ((aluc == ADDU || aluc == SUBU) && (res[31] != (a[31] ^ b[31])));

    assign r = res;
    assign flag = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;

endmodule