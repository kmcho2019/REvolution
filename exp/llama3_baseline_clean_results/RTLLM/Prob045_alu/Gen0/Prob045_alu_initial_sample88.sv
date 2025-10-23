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
wire [31:0] sa;

assign sa = (aluc == SLLV) ? b : {5'b0, a[4:0]};

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            {carry, res} = a + b;
        end
        ADDU: begin
            {carry, res} = {1'b0, a} + {1'b0, b};
        end
        SUB: begin
            {carry, res} = a - b;
        end
        SUBU: begin
            {carry, res} = {1'b0, a} - {1'b0, b};
        end
        AND: begin
            res = a & b;
            carry = 0;
        end
        OR: begin
            res = a | b;
            carry = 0;
        end
        XOR: begin
            res = a ^ b;
            carry = 0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 0;
        end
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'b1 : 32'b0;
            carry = 0;
        end
        SLTU: begin
            res = (a < b) ? 32'b1 : 32'b0;
            carry = 0;
        end
        SLL: begin
            res = a << b[4:0];
            carry = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry = 0;
        end
        SRA: begin
            res = signed'(a) >>> b[4:0];
            carry = 0;
        end
        SLLV: begin
            res = a << b[4:0];
            carry = 0;
        end
        SRLV: begin
            res = a >> b[4:0];
            carry = 0;
        end
        SRAV: begin
            res = signed'(a) >>> b[4:0];
            carry = 0;
        end
        LUI: begin
            res = {16'b0, a[15:0]};
            carry = 0;
        end
        default: begin
            res = 32'bz;
            carry = 0;
        end
    endcase
end

assign r = res;
assign zero = (res == 32'b0);
assign negative = res[31];
assign overflow = (aluc == ADD || aluc == SUB) && ((a[31] == b[31] && res[31] != a[31]) || (a[31] != b[31] && res[31] == a[31]));
assign flag = (aluc == SLT || aluc == SLTU);

endmodule