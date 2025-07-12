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
wire [4:0] shamt_fixed = a[4:0];
wire [4:0] shamt_var = a[4:0];

always @* begin
    // Default assignments to avoid latches
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = a + b;
            // Overflow detection for signed addition
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} = a + b;
            // carry valid only for unsigned add
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = a - b;
            // Overflow detection for signed subtraction
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
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b);
            r = {31'b0, flag};
        end
        SLL:  r = b << shamt_fixed;
        SRL:  r = b >> shamt_fixed;
        SRA:  r = $signed(b_s) >>> shamt_fixed;
        SLLV: r = b << shamt_var;
        SRLV: r = b >> shamt_var;
        SRAV: r = $signed(b_s) >>> shamt_var;
        LUI:  r = {a[15:0], 16'd0};
        default: begin
            // For undefined instructions, output zero and clear flags
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