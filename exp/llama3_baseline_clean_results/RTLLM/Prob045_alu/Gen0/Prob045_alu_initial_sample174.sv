// Define the operation parameters
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

reg [31:0] res;
wire signed [31:0] sa, sb;

assign sa = a;
assign sb = b;
assign r = res;
assign zero = (res == 32'd0);
assign negative = res[31];
assign flag = (aluc == SLT || aluc == SLTU) ? (sa < sb) : 1'bz;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, res} = sa + sb;
            overflow = (sa[31] == sb[31] && sa[31] != res[31]);
        end
        ADDU: begin
            {carry, res} = {1'b0, a} + {1'b0, b};
            overflow = 1'b0;
        end
        SUB: begin
            {carry, res} = sa - sb;
            overflow = (sa[31] != sb[31] && sa[31] != res[31]);
        end
        SUBU: begin
            {carry, res} = {1'b0, a} - {1'b0, b};
            overflow = 1'b0;
        end
        AND: begin
            res = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            res = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            res = (sa < sb) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            res = sa >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            res = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            res = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            res = sa >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            res = {b[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            res = 32'bz;
            carry = 1'bz;
            overflow = 1'bz;
        end
    endcase
end

endmodule