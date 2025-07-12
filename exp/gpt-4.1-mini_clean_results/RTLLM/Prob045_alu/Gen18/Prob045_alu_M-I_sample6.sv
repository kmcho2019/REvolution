module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

always @* begin
    // Default assignments
    r = 32'd0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = a + b;
            // Overflow occurs if operands have same sign but result sign differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} = a + b;
            // Unsigned addition: overflow flag not meaningful
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = a - b;
            // Overflow if signs of a and b differ and sign of result differs from a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        AND:  r = a & b;
        OR:   r = a | b;
        XOR:  r = a ^ b;
        NOR:  r = ~(a | b);
        SLT: begin
            flag = (a_s < b_s);
            r = {31'd0, flag};
        end
        SLTU: begin
            flag = (a < b);
            r = {31'd0, flag};
        end
        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = $signed(b_s) >>> shamt;
        SLLV: r = b << a[4:0];
        SRLV: r = b >> a[4:0];
        SRAV: r = $signed(b_s) >>> a[4:0];
        LUI:  r = b << 16;
        default: begin
            r = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'd0);
    negative = r[31];
end

endmodule