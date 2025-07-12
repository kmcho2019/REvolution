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
reg zero_out, carry_out, negative_out, overflow_out, flag_out;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            {carry_out, res} = a + b;
            overflow_out = (a[31] == b[31] && a[31] != res[31]);
        end
        ADDU: begin
            {carry_out, res} = a + b;
            overflow_out = 0;
        end
        SUB: begin
            {carry_out, res} = a - b;
            overflow_out = (a[31] != b[31] && a[31] != res[31]);
        end
        SUBU: begin
            {carry_out, res} = a - b;
            overflow_out = 0;
        end
        AND: begin
            res = a & b;
            carry_out = 0;
            overflow_out = 0;
        end
        OR: begin
            res = a | b;
            carry_out = 0;
            overflow_out = 0;
        end
        XOR: begin
            res = a ^ b;
            carry_out = 0;
            overflow_out = 0;
        end
        NOR: begin
            res = ~(a | b);
            carry_out = 0;
            overflow_out = 0;
        end
        SLT: begin
            res = (a < b) ? 1 : 0;
            carry_out = 0;
            overflow_out = 0;
            flag_out = res;
        end
        SLTU: begin
            res = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
            carry_out = 0;
            overflow_out = 0;
            flag_out = res;
        end
        SLL: begin
            res = a << b[4:0];
            carry_out = 0;
            overflow_out = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry_out = 0;
            overflow_out = 0;
        end
        SRA: begin
            res = a >>> b[4:0];
            carry_out = 0;
            overflow_out = 0;
        end
        SLLV: begin
            res = a << b;
            carry_out = 0;
            overflow_out = 0;
        end
        SRLV: begin
            res = a >> b;
            carry_out = 0;
            overflow_out = 0;
        end
        SRAV: begin
            res = a >>> b;
            carry_out = 0;
            overflow_out = 0;
        end
        LUI: begin
            res = {b[15:0], 16'd0};
            carry_out = 0;
            overflow_out = 0;
        end
        default: begin
            res = 32'bz;
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
    endcase

    zero_out = (res == 0);
    negative_out = res[31];
end

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

endmodule