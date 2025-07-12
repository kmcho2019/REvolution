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

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            {carry_out, res} = a + (aluc == ADDU ? b : b);
            overflow_out = (aluc == ADD) && (a[31] == b[31] && a[31] != res[31]);
        end
        SUB, SUBU: begin
            {carry_out, res} = a - (aluc == SUBU ? b : b);
            overflow_out = (aluc == SUB) && (a[31] != b[31] && a[31] != res[31]);
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag_out = (signed'(a) < signed'(b)) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag_out = (a < b) ? 1'b1 : 1'b0;
        end
        SLL, SLLV: begin
            res = (aluc == SLL) ? a << b[4:0] : a << b;
        end
        SRL, SRLV: begin
            res = (aluc == SRL) ? a >> b[4:0] : a >> b;
        end
        SRA, SRAV: begin
            res = (aluc == SRA) ? a >>> b[4:0] : a >>> b;
        end
        LUI: res = {a[15:0], 16'd0};
    endcase

    zero_out = (res == 32'd0);
    negative_out = res[31];
    carry_out = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
end

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

endmodule