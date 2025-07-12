module alu (
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
    // ALU opcodes
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

    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;
    wire [4:0] shamt = a[4:0];
    reg signed [31:0] r_s;

    always @(*) begin
        // defaults
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                r_s = a_s + b_s;
                r = r_s;
                // Overflow detection for signed addition:
                // overflow if a and b have same sign but r has different sign
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                carry = 1'b0; // no carry flag for signed add
            end
            ADDU: begin
                {carry, r} = a + b;
                overflow = 1'b0;
            end
            SUB: begin
                r_s = a_s - b_s;
                r = r_s;
                // overflow if a and b differ sign and result sign differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                carry = 1'b0;
            end
            SUBU: begin
                {carry, r} = a - b;
                overflow = 1'b0;
                // carry here indicates borrow for unsigned subtraction, so invert
                carry = ~carry;
            end
            AND: begin
                r = a & b;
            end
            OR: begin
                r = a | b;
            end
            XOR: begin
                r = a ^ b;
            end
            NOR: begin
                r = ~(a | b);
            end
            SLT: begin
                flag = (a_s < b_s);
                r = flag ? 32'd1 : 32'd0;
            end
            SLTU: begin
                flag = (a < b);
                r = flag ? 32'd1 : 32'd0;
            end
            SLL, SLLV: begin
                // shift amount depends on instruction
                r = b << shamt;
            end
            SRL, SRLV: begin
                r = b >> shamt;
            end
            SRA, SRAV: begin
                r = $signed(b) >>> shamt;
            end
            LUI: begin
                // upper 16 bits of a concatenated with 16 zeros
                r = {a[31:16], 16'b0};
            end
            default: begin
                r = 32'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];
endmodule