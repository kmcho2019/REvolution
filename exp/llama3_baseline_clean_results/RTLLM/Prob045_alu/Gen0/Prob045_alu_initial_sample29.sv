module alu(
    input  wire [31:0] a,    // 32-bit input operand
    input  wire [31:0] b,    // 32-bit input operand
    input  wire [5:0]  aluc, // 6-bit control signal
    output reg  [31:0] r,   // 32-bit output representing the result
    output reg         zero, // 1-bit output indicating whether the result is zero
    output reg         carry, // 1-bit output indicating whether a carry occurred
    output reg         negative, // 1-bit output indicating whether the result is negative
    output reg         overflow, // 1-bit output indicating whether an overflow occurred
    output reg         flag  // 1-bit output representing a general flag
);

parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

reg [31:0] res;
reg [31:0] signed_a, signed_b;

assign signed_a = a;
assign signed_b = b;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, res} = signed_a + signed_b;
            overflow = (signed_a[31] == signed_b[31] && signed_a[31]!= res[31]);
        end
        ADDU: begin
            {carry, res} = a + b;
        end
        SUB: begin
            {carry, res} = signed_a - signed_b;
            overflow = (signed_a[31]!= signed_b[31] && signed_a[31]!= res[31]);
        end
        SUBU: begin
            {carry, res} = a - b;
        end
        AND: begin
            res = a & b;
            carry = 0;
            overflow = 0;
        end
        OR: begin
            res = a | b;
            carry = 0;
            overflow = 0;
        end
        XOR: begin
            res = a ^ b;
            carry = 0;
            overflow = 0;
        end
        NOR: begin
            res = ~(a | b);
            carry = 0;
            overflow = 0;
        end
        SLT: begin
            res = (signed_a < signed_b)? 1 : 0;
            carry = 0;
            overflow = 0;
            flag = res;
        end
        SLTU: begin
            res = (a < b)? 1 : 0;
            carry = 0;
            overflow = 0;
            flag = res;
        end
        SLL: begin
            res = a << a[4:0];
            carry = 0;
            overflow = 0;
        end
        SRL: begin
            res = a >> a[4:0];
            carry = 0;
            overflow = 0;
        end
        SRA: begin
            res = signed_a >>> a[4:0];
            carry = 0;
            overflow = 0;
        end
        SLLV: begin
            res = a << b[4:0];
            carry = 0;
            overflow = 0;
        end
        SRLV: begin
            res = a >> b[4:0];
            carry = 0;
            overflow = 0;
        end
        SRAV: begin
            res = signed_a >>> b[4:0];
            carry = 0;
            overflow = 0;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            carry = 0;
            overflow = 0;
        end
        default: begin
            res = 'z;
            carry = 'z;
            overflow = 'z;
            flag = 'z;
        end
    endcase
    
    r = res;
    zero = (res == 0);
    negative = res[31];
end

endmodule