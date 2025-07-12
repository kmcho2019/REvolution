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

wire [31:0] res;
wire [31:0] signed_a, signed_b;
assign signed_a = a;
assign signed_b = b;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            res = signed_a + signed_b;
        end
        ADDU: begin
            res = a + b;
        end
        SUB: begin
            res = signed_a - signed_b;
        end
        SUBU: begin
            res = a - b;
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
            res = (signed_a < signed_b) ? 32'd1 : 32'd0;
            flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b) ? 1'b1 : 1'b0;
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
            res = a << b;
        end
        SRLV: begin
            res = a >> b;
        end
        SRAV: begin
            res = signed_a >>> b;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
        end
        default: begin
            res = 32'dz;
        end
    endcase
end

assign r = res;
assign zero = (res == 32'd0) ? 1'b1 : 1'b0;
assign carry = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign overflow = ((aluc == ADD || aluc == SUB) && ((signed_a[31] == signed_b[31] && res[31] != signed_a[31]) || (signed_a[31] != signed_b[31] && res[31] == signed_a[31]))) ? 1'b1 : 1'b0;

endmodule