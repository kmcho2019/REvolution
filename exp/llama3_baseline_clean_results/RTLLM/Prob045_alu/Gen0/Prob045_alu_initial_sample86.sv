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

reg [31:0] signed_a, signed_b;
reg signed_r;
reg [31:0] res;

assign signed_a = a;
assign signed_b = b;

always @(*) begin
    case(aluc)
        ADD: begin
            res = signed_a + signed_b;
            overflow = ((signed_a[31] == signed_b[31]) && (signed_a[31] != res[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            res = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            res = signed_a - signed_b;
            overflow = ((signed_a[31] == signed_b[31]) && (signed_a[31] != res[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            res = a - b;
            overflow = 1'b0;
        end
        AND: begin
            res = a & b;
            overflow = 1'b0;
        end
        OR: begin
            res = a | b;
            overflow = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            overflow = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            overflow = 1'b0;
        end
        SLT: begin
            res = (signed_a < signed_b) ? 32'b1 : 32'b0;
            flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            res = (a < b) ? 32'b1 : 32'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            overflow = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            overflow = 1'b0;
        end
        SRA: begin
            res = signed_a >>> b[4:0];
            overflow = 1'b0;
        end
        SLLV: begin
            res = a << a[4:0];
            overflow = 1'b0;
        end
        SRLV: begin
            res = a >> a[4:0];
            overflow = 1'b0;
        end
        SRAV: begin
            res = signed_a >>> a[4:0];
            overflow = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            overflow = 1'b0;
        end
        default: begin
            res = 32'bz;
            overflow = 1'b0;
        end
    endcase
    r = res;
    zero = (res == 32'b0) ? 1'b1 : 1'b0;
    carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? (res[31] != res[0]) : 1'b0;
    negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
end

endmodule