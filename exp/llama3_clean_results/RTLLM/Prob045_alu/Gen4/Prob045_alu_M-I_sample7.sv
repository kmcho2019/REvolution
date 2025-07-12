module alu(
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
reg [31:0] temp_a, temp_b;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            temp_a = a;
            temp_b = b;
            res = temp_a + temp_b;
        end
        ADDU: begin
            temp_a = {32'd0, a};
            temp_b = {32'd0, b};
            res = temp_a + temp_b;
        end
        SUB: begin
            temp_a = a;
            temp_b = b;
            res = temp_a - temp_b;
        end
        SUBU: begin
            temp_a = {32'd0, a};
            temp_b = {32'd0, b};
            res = temp_a - temp_b;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        SLTU: res = (a < b)? 32'd1 : 32'd0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = a >>> a[4:0];
        LUI: res = {b[15:0], 16'd0};
        default: res = 32'bz;
    endcase

    r = res;
    zero = (res == 0);
    carry = ((aluc == ADD) || (aluc == ADDU))? (temp_a[31] == temp_b[31] && temp_a[31]!= res[31]) : 0;
    negative = res[31];
    overflow = ((aluc == ADD) || (aluc == ADDU))? (temp_a[31] == temp_b[31] && temp_a[31]!= res[31]) : 0;
    flag = ((aluc == SLT) || (aluc == SLTU))? (res[0] == 1) : 0;
end

endmodule