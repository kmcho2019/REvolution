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

assign r = res;
assign zero = zero_out;
assign carry = carry_out;
assign negative = negative_out;
assign overflow = overflow_out;
assign flag = flag_out;

always @(*)
begin
    case(aluc)
        ADD: 
        begin
            {carry_out, res} = a + b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = ((a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b0 && res[31] == 1'b1));
            flag_out = 1'bz;
        end
        ADDU: 
        begin
            {carry_out, res} = a + b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            flag_out = 1'bz;
        end
        SUB: 
        begin
            {carry_out, res} = a - b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = ((a[31] == 1'b1 && b[31] == 1'b0 && res[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b1 && res[31] == 1'b1));
            flag_out = 1'bz;
        end
        SUBU: 
        begin
            {carry_out, res} = a - b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            flag_out = 1'bz;
        end
        AND: 
        begin
            res = a & b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        OR: 
        begin
            res = a | b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        XOR: 
        begin
            res = a ^ b;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        NOR: 
        begin
            res = ~(a | b);
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SLT: 
        begin
            if ($signed(a) < $signed(b)) 
                res = 32'd1;
            else 
                res = 32'd0;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = (res == 32'd1);
        end
        SLTU: 
        begin
            if (a < b) 
                res = 32'd1;
            else 
                res = 32'd0;
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = (res == 32'd1);
        end
        SLL: 
        begin
            res = a << a[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SRL: 
        begin
            res = a >> a[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SRA: 
        begin
            res = a >>> a[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SLLV: 
        begin
            res = a << b[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SRLV: 
        begin
            res = a >> b[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        SRAV: 
        begin
            res = a >>> b[4:0];
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        LUI: 
        begin
            res = {a[15:0], 16'd0};
            zero_out = (res == 32'd0);
            negative_out = (res[31] == 1'b1);
            overflow_out = 1'b0;
            carry_out = 1'b0;
            flag_out = 1'bz;
        end
        default: 
        begin
            res = 32'bz;
            zero_out = 1'bz;
            negative_out = 1'bz;
            overflow_out = 1'bz;
            carry_out = 1'bz;
            flag_out = 1'bz;
        end
    endcase
end

endmodule