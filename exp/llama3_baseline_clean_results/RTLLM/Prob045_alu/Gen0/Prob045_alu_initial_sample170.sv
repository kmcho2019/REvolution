module alu (
    input wire [31:0] a, 
    input wire [31:0] b, 
    input wire [5:0] aluc, 
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
    wire signed [31:0] a_signed;
    wire unsigned [31:0] a_unsigned;
    wire signed [31:0] b_signed;
    wire unsigned [31:0] b_unsigned;

    assign a_signed = a;
    assign a_unsigned = a;
    assign b_signed = b;
    assign b_unsigned = b;
    assign r = res;

    always @(*) begin
        case(aluc)
            ADD: begin
                res = a_signed + b_signed;
                carry = (a_unsigned + b_unsigned > 32'd4294967295);
                overflow = (a_signed[31] == b_signed[31]) && (a_signed[31] != res[31]);
            end
            ADDU: begin
                res = a_unsigned + b_unsigned;
                carry = (a_unsigned + b_unsigned > 32'd4294967295);
            end
            SUB: begin
                res = a_signed - b_signed;
                carry = (a_unsigned < b_unsigned);
                overflow = (a_signed[31] != b_signed[31]) && (a_signed[31] != res[31]);
            end
            SUBU: begin
                res = a_unsigned - b_unsigned;
                carry = (a_unsigned < b_unsigned);
            end
            AND: begin
                res = a & b;
            end
            OR: begin
                res = a | b;
            end
            XOR: begin
                res = a ^ b;
            end
            NOR: begin
                res = ~(a | b);
            end
            SLT: begin
                res = (a_signed < b_signed) ? 1 : 0;
                flag = (a_signed < b_signed);
            end
            SLTU: begin
                res = (a_unsigned < b_unsigned) ? 1 : 0;
                flag = (a_unsigned < b_unsigned);
            end
            SLL: begin
                res = a_signed << b[4:0];
            end
            SRL: begin
                res = a_unsigned >> b[4:0];
            end
            SRA: begin
                res = a_signed >> b[4:0];
            end
            SLLV: begin
                res = a_signed << b[4:0];
            end
            SRLV: begin
                res = a_unsigned >> b[4:0];
            end
            SRAV: begin
                res = a_signed >> b[4:0];
            end
            LUI: begin
                res = {a[15:0], 16'd0};
            end
            default: begin
                res = 32'd0;
            end
        endcase
        zero = (res == 0);
        negative = (res[31] == 1'b1);
    end

endmodule