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

    reg [31:0] res;
    reg [31:0] signed_a;
    reg [31:0] signed_b;

    assign signed_a = a;
    assign signed_b = b;

    always @(*) begin
        case (aluc)
            ADD: begin
                res = signed_a + signed_b;
                carry = (res[31:0] + signed_a[31:0] + signed_b[31:0] > 32'hffffffff) ? 1'b1 : 1'b0;
                overflow = (signed_a[31] == signed_b[31] && signed_a[31] != res[31]) ? 1'b1 : 1'b0;
            end
            ADDU: begin
                res = a + b;
                carry = (res[31:0] + a[31:0] + b[31:0] > 32'hffffffff) ? 1'b1 : 1'b0;
                overflow = 1'b0;
            end
            SUB: begin
                res = signed_a - signed_b;
                carry = (signed_a[31:0] - signed_b[31:0] < 0) ? 1'b1 : 1'b0;
                overflow = (signed_a[31] != signed_b[31] && signed_a[31] != res[31]) ? 1'b1 : 1'b0;
            end
            SUBU: begin
                res = a - b;
                carry = (a[31:0] - b[31:0] < 0) ? 1'b1 : 1'b0;
                overflow = 1'b0;
            end
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = (signed_a < signed_b) ? 32'h1 : 32'h0;
                flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
            end
            SLTU: begin
                res = (a < b) ? 32'h1 : 32'h0;
                flag = (a < b) ? 1'b1 : 1'b0;
            end
            SLL: res = a << 5'b00000;
            SRL: res = a >> 5'b00000;
            SRA: res = signed_a >>> 5'b00000;
            SLLV: res = a << b[4:0];
            SRLV: res = a >> b[4:0];
            SRAV: res = signed_a >>> b[4:0];
            LUI: res = {a[15:0], 16'h0};
            default: res = 32'hxxxxxxxx;
        endcase

        r = res;
        zero = (res == 32'h0) ? 1'b1 : 1'b0;
        negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
    end

endmodule