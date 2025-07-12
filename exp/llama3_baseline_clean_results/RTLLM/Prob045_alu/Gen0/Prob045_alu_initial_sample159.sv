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

reg [32:0] temp;
reg [31:0] res;

always @(*) begin
    temp = 0;
    res = 0;
    carry = 0;
    overflow = 0;
    zero = 0;
    negative = 0;
    flag = 0;

    case (aluc)
        ADD: begin
            temp = $signed(a) + $signed(b);
            res = temp[31:0];
            if (temp[32] == 1'b1) overflow = 1'b1;
        end
        ADDU: begin
            temp = {1'b0, a} + {1'b0, b};
            res = temp[31:0];
            if (temp[32] == 1'b1) carry = 1'b1;
        end
        SUB: begin
            temp = $signed(a) - $signed(b);
            res = temp[31:0];
            if (temp[32] == 1'b1) overflow = 1'b1;
        end
        SUBU: begin
            temp = {1'b0, a} - {1'b0, b};
            res = temp[31:0];
            if (temp[32] == 1'b1) carry = 1'b1;
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
            if ($signed(a) < $signed(b)) res = 32'd1;
            else res = 32'd0;
            flag = (res == 32'd1);
        end
        SLTU: begin
            if (a < b) res = 32'd1;
            else res = 32'd0;
            flag = (res == 32'd1);
        end
        SLL: begin
            res = a << b[4:0];
        end
        SRL: begin
            res = a >> b[4:0];
        end
        SRA: begin
            res = $signed(a) >>> b[4:0];
        end
        SLLV: begin
            res = a << b;
        end
        SRLV: begin
            res = a >> b;
        end
        SRAV: begin
            res = $signed(a) >>> b;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
        end
        default: begin
            res = 32'bz;
        end
    endcase

    if (res == 32'd0) zero = 1'b1;
    if (res[31] == 1'b1) negative = 1'b1;
    r = res;
end

endmodule