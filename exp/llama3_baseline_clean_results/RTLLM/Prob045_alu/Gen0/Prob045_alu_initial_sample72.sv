module alu (
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

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

always @(*) begin
    res = 32'bx;
    zero_out = 0;
    carry_out = 0;
    negative_out = 0;
    overflow_out = 0;
    flag_out = 0;

    case (aluc)
        ADD: begin
            {carry_out, res} = a + b;
            if (res == 0) zero_out = 1;
            if (res[31]) negative_out = 1;
            if ((a[31] == b[31]) && (a[31] != res[31])) overflow_out = 1;
        end
        ADDU: begin
            {carry_out, res} = a + b;
            if (res == 0) zero_out = 1;
        end
        SUB: begin
            {carry_out, res} = a - b;
            if (res == 0) zero_out = 1;
            if (res[31]) negative_out = 1;
            if ((a[31] == b[31]) && (a[31] != res[31])) overflow_out = 1;
        end
        SUBU: begin
            {carry_out, res} = a - b;
            if (res == 0) zero_out = 1;
        end
        AND: begin
            res = a & b;
            if (res == 0) zero_out = 1;
        end
        OR: begin
            res = a | b;
            if (res == 0) zero_out = 1;
        end
        XOR: begin
            res = a ^ b;
            if (res == 0) zero_out = 1;
        end
        NOR: begin
            res = ~(a | b);
            if (res == 0) zero_out = 1;
        end
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag_out = res[0];
            if (res == 0) zero_out = 1;
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag_out = res[0];
            if (res == 0) zero_out = 1;
        end
        SLL: begin
            res = a << b[4:0];
            if (res == 0) zero_out = 1;
        end
        SRL: begin
            res = a >> b[4:0];
            if (res == 0) zero_out = 1;
        end
        SRA: begin
            res = a >>> b[4:0];
            if (res == 0) zero_out = 1;
        end
        SLLV: begin
            res = a << b[4:0];
            if (res == 0) zero_out = 1;
        end
        SRLV: begin
            res = a >> b[4:0];
            if (res == 0) zero_out = 1;
        end
        SRAV: begin
            res = a >>> b[4:0];
            if (res == 0) zero_out = 1;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            if (res == 0) zero_out = 1;
        end
        default: res = 32'bx;
    endcase

    if (res[31]) negative_out = 1;
end

endmodule