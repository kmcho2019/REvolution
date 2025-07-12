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
reg zero_out;
reg carry_out;
reg negative_out;
reg overflow_out;
reg flag_out;

always @(a, b, aluc) begin
    case(aluc)
        ADD: begin
            {carry_out, res} = a + b;
            overflow_out = (a[31] == b[31] && a[31] != res[31]);
        end
        ADDU: begin
            {carry_out, res} = {1'b0, a} + {1'b0, b};
        end
        SUB: begin
            {carry_out, res} = a - b;
            overflow_out = (a[31] != b[31] && a[31] != res[31]);
        end
        SUBU: begin
            {carry_out, res} = {1'b0, a} - {1'b0, b};
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            flag_out = (signed'(a) < signed'(b));
            res = 32'b0;
        end
        SLTU: begin
            flag_out = (a < b);
            res = 32'b0;
        end
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = {a[31], a[31:1]} >> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = {a[31], a[31:1]} >> b;
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'bz;
    endcase
    zero_out = (res == 32'b0);
    negative_out = res[31];
end

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

endmodule