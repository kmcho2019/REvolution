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
reg zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

always @(a or b or aluc) begin
    case(aluc)
        ADD: begin
            res = a + b;
            carry_reg = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0);
            overflow_reg = (a[31] != b[31] && a[31] != res[31]);
        end
        ADDU: begin
            res = a + b;
            carry_reg = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0);
            overflow_reg = 1'b0;
        end
        SUB: begin
            res = a - b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1);
            overflow_reg = (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1);
        end
        SUBU: begin
            res = a - b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1);
            overflow_reg = 1'b0;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res = (a < b) ? 1 : 0;
            flag_reg = (a < b);
        end
        SLTU: begin
            res = ({32{1'b0}} + a < {32{1'b0}} + b) ? 1 : 0;
            flag_reg = ({32{1'b0}} + a < {32{1'b0}} + b);
        end
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = {a[31], a[31:1]};
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = {a[31], a[31:1]};
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'bz;
    endcase
    zero_reg = (res == 32'b0);
    negative_reg = res[31];
end

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule