module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);

// Opcode parameters
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

wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;
wire [4:0] shamt = a[4:0];

always @(*) begin
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    case (aluc)
        ADD: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            // Overflow if a and b sign bits equal and differ from result sign
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            carry = (a >= b) ? 1'b1 : 1'b0; // carry means no borrow
            // Overflow if signs of a and b differ and sign of result differs from a
            overflow = (a[31] ^ b[31]) & (r[31] ^ a[31]);
        end
        SUBU: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            carry = (a >= b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: begin
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = $signed(b) >>> shamt;
        SLLV: r = b << shamt;
        SRLV: r = b >> shamt;
        SRAV: r = $signed(b) >>> shamt;
        LUI:  r = {b[15:0], 16'b0};
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule