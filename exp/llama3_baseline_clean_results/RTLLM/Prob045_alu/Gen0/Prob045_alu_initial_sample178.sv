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
reg [31:0] temp;
reg zero_out;
reg carry_out;
reg negative_out;
reg overflow_out;
reg flag_out;

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry_out, res} = a + b;
            overflow_out = (a[31] == b[31] && a[31] != res[31]);
            zero_out = (res == 0);
            negative_out = res[31];
            flag_out = 0;
        end
        ADDU: begin
            {carry_out, res} = a + b;
            overflow_out = 0;
            zero_out = (res == 0);
            negative_out = res[31];
            flag_out = 0;
        end
        SUB: begin
            {carry_out, res} = a - b;
            overflow_out = (a[31] != b[31] && a[31] != res[31]);
            zero_out = (res == 0);
            negative_out = res[31];
            flag_out = 0;
        end
        SUBU: begin
            {carry_out, res} = a - b;
            overflow_out = 0;
            zero_out = (res == 0);
            negative_out = res[31];
            flag_out = 0;
        end
        AND: begin
            res = a & b;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        OR: begin
            res = a | b;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        XOR: begin
            res = a ^ b;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        NOR: begin
            res = ~(a | b);
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 1 : 0;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = (signed'(a) < signed'(b));
        end
        SLTU: begin
            res = (a < b) ? 1 : 0;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SRA: begin
            res = (signed'(a) >>> b[4:0]);
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SLLV: begin
            res = a << b;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SRLV: begin
            res = a >> b;
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        SRAV: begin
            res = (signed'(a) >>> b);
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            zero_out = (res == 0);
            negative_out = res[31];
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
        default: begin
            res = 32'bz;
            zero_out = 0;
            negative_out = 0;
            carry_out = 0;
            overflow_out = 0;
            flag_out = 0;
        end
    endcase
end

endmodule