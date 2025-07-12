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

wire [31:0] signed_a;
wire [31:0] signed_b;

assign signed_a = a;
assign signed_b = b;

reg [31:0] res;

always @(*)
begin
    case(aluc)
        ADD: 
        begin
            {carry, res} = signed_a + signed_b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = (signed_a[31] == signed_b[31] && signed_a[31] != res[31]);
            flag = 1'bz;
        end
        ADDU: 
        begin
            {carry, res} = a + b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            flag = 1'bz;
        end
        SUB: 
        begin
            {carry, res} = signed_a - signed_b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = (signed_a[31] != signed_b[31] && signed_a[31] != res[31]);
            flag = 1'bz;
        end
        SUBU: 
        begin
            {carry, res} = a - b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            flag = 1'bz;
        end
        AND: 
        begin
            res = a & b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        OR: 
        begin
            res = a | b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        XOR: 
        begin
            res = a ^ b;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        NOR: 
        begin
            res = ~(a | b);
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SLT: 
        begin
            res = (signed_a < signed_b) ? 32'd1 : 32'd0;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
        end
        SLTU: 
        begin
            res = (a < b) ? 32'd1 : 32'd0;
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: 
        begin
            res = a << b[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SRL: 
        begin
            res = a >> b[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SRA: 
        begin
            res = signed_a >>> b[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SLLV: 
        begin
            res = a << a[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SRLV: 
        begin
            res = a >> a[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        SRAV: 
        begin
            res = signed_a >>> a[4:0];
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        LUI: 
        begin
            res = {a[15:0], 16'd0};
            if (res == 0)
                zero = 1'b1;
            else
                zero = 1'b0;
            negative = res[31];
            overflow = 1'b0;
            carry = 1'b0;
            flag = 1'bz;
        end
        default: 
        begin
            res = 32'bz;
            zero = 1'bz;
            negative = 1'bz;
            overflow = 1'bz;
            carry = 1'bz;
            flag = 1'bz;
        end
    endcase
end

assign r = res;

endmodule