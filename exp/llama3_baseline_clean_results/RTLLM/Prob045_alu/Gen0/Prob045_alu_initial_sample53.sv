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
reg [31:0] signed_a;
reg [31:0] signed_b;
reg zero_out;
reg carry_out;
reg negative_out;
reg overflow_out;
reg flag_out;

always @(*)
begin
    signed_a = $signed(a);
    signed_b = $signed(b);
    res = 32'bz;
    zero_out = 1'b0;
    carry_out = 1'b0;
    negative_out = 1'b0;
    overflow_out = 1'b0;
    flag_out = 1'b0;

    case (aluc)
        ADD: 
        begin
            {carry_out, res} = signed_a + signed_b;
            if (res == 32'd0) zero_out = 1'b1;
            if (res[31]) negative_out = 1'b1;
            if (signed_a[31] == signed_b[31] && signed_a[31] != res[31]) overflow_out = 1'b1;
        end
        ADDU: 
        begin
            {carry_out, res} = a + b;
            if (res == 32'd0) zero_out = 1'b1;
            if (res[31]) negative_out = 1'b1;
        end
        SUB: 
        begin
            {carry_out, res} = signed_a - signed_b;
            if (res == 32'd0) zero_out = 1'b1;
            if (res[31]) negative_out = 1'b1;
            if (signed_a[31] != signed_b[31] && signed_a[31] != res[31]) overflow_out = 1'b1;
        end
        SUBU: 
        begin
            {carry_out, res} = a - b;
            if (res == 32'd0) zero_out = 1'b1;
            if (res[31]) negative_out = 1'b1;
        end
        AND: 
        begin
            res = a & b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        OR: 
        begin
            res = a | b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        XOR: 
        begin
            res = a ^ b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        NOR: 
        begin
            res = ~(a | b);
            if (res == 32'd0) zero_out = 1'b1;
        end
        SLT: 
        begin
            if (signed_a < signed_b) 
            begin
                res = 32'd1;
                flag_out = 1'b1;
            end
            else 
            begin
                res = 32'd0;
            end
            if (res == 32'd0) zero_out = 1'b1;
        end
        SLTU: 
        begin
            if (a < b) 
            begin
                res = 32'd1;
                flag_out = 1'b1;
            end
            else 
            begin
                res = 32'd0;
            end
            if (res == 32'd0) zero_out = 1'b1;
        end
        SLL: 
        begin
            res = a << b[4:0];
            if (res == 32'd0) zero_out = 1'b1;
        end
        SRL: 
        begin
            res = a >> b[4:0];
            if (res == 32'd0) zero_out = 1'b1;
        end
        SRA: 
        begin
            res = signed_a >>> b[4:0];
            if (res == 32'd0) zero_out = 1'b1;
        end
        SLLV: 
        begin
            res = a << b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        SRLV: 
        begin
            res = a >> b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        SRAV: 
        begin
            res = signed_a >>> b;
            if (res == 32'd0) zero_out = 1'b1;
        end
        LUI: 
        begin
            res = {a[15:0], 16'd0};
            if (res == 32'd0) zero_out = 1'b1;
        end
        default: 
        begin
            res = 32'bz;
        end
    endcase
end

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

endmodule