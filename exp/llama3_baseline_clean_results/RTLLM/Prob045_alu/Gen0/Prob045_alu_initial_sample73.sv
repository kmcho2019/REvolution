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

always @(*) begin
    signed_a = a;
    signed_b = b;
    case (aluc)
        ADD: begin
            {carry, res} = signed_a + signed_b;
            overflow = (signed_a[31] == signed_b[31] && signed_a[31]!= res[31]);
        end
        ADDU: begin
            {carry, res} = a + b;
        end
        SUB: begin
            {carry, res} = signed_a - signed_b;
            overflow = (signed_a[31]!= signed_b[31] && signed_a[31]!= res[31]);
        end
        SUBU: begin
            {carry, res} = a - b;
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
            res = (signed_a < signed_b)? 32'd1 : 32'd0;
            flag = (signed_a < signed_b);
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            flag = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
        end
        SRL: begin
            res = a >> b[4:0];
        end
        SRA: begin
            res = signed_a >>> b[4:0];
        end
        SLLV: begin
            res = a << a[4:0];
        end
        SRLV: begin
            res = a >> a[4:0];
        end
        SRAV: begin
            res = signed_a >>> a[4:0];
        end
        LUI: begin
            res = {a[15:0], 16'd0};
        end
        default: begin
            res = 32'bz;
        end
    endcase
    r = res;
    zero = (res == 32'd0);
    negative = res[31];
end

endmodule