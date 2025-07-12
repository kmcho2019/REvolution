module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
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

assign zero = (res == 32'd0)? 1'b1 : 1'b0;
assign negative = res[31];
assign overflow = (aluc == ADD || aluc == SUB)? (a[31] == b[31] && a[31]!= res[31]) : 1'b0;
assign carry = (aluc == ADD || aluc == SUB)? (a[31] == b[31] && a[31]!= res[31]) : 1'b0;

always @(*)
begin
    case (aluc)
        ADD: begin
            {carry, res} = a + b;
            flag = 1'b0;
        end
        ADDU: begin
            {carry, res} = a + b;
            flag = 1'b0;
        end
        SUB: begin
            {carry, res} = a - b;
            flag = 1'b0;
        end
        SUBU: begin
            {carry, res} = a - b;
            flag = 1'b0;
        end
        AND: begin
            res = a & b;
            carry = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            res = a | b;
            carry = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            carry = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            res = (a < b)? 32'd1 : 32'd0;
            carry = 1'b0;
            flag = (a < b)? 1'b1 : 1'b0;
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            carry = 1'b0;
            flag = (a < b)? 1'b1 : 1'b0;
        end
        SLL: begin
            res = a << b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            res = a >>> b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            res = a << b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            res = a >> b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            res = a >>> b[4:0];
            carry = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            carry = 1'b0;
            flag = 1'b0;
        end
        default: begin
            res = 32'bz;
            carry = 1'bz;
            flag = 1'bz;
        end
    endcase
end

assign r = res;

endmodule