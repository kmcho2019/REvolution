module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
);

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR  = 6'b100101;
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
wire [31:0] unsigned_a;
wire [31:0] unsigned_b;
reg  [31:0] res;

assign signed_a = a;
assign signed_b = b;
assign unsigned_a = a;
assign unsigned_b = b;

always @(*)
begin
    case (aluc)
        ADD: begin
            {carry, res} = signed_a + signed_b;
            overflow = (signed_a[31] == signed_b[31]) && (signed_a[31]!= res[31]);
        end
        ADDU: begin
            {carry, res} = unsigned_a + unsigned_b;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, res} = signed_a - signed_b;
            overflow = (signed_a[31]!= signed_b[31]) && (signed_a[31]!= res[31]);
        end
        SUBU: begin
            {carry, res} = unsigned_a - unsigned_b;
            overflow = 1'b0;
        end
        AND: begin
            res = signed_a & signed_b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            res = signed_a | signed_b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            res = signed_a ^ signed_b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            res = ~(signed_a | signed_b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            res = (signed_a < signed_b)? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            res = (unsigned_a < unsigned_b)? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            res = signed_a << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            res = signed_a >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            res = signed_a >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            res = signed_a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            res = signed_a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            res = signed_a >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            res = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

assign r = res;
assign zero = (res == 32'd0);
assign negative = res[31];
assign flag = (aluc == SLT || aluc == SLTU)? res[0] : 1'bz;

endmodule