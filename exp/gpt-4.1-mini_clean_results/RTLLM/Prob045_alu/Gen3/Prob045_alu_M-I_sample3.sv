module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output flag
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

    wire [4:0] shamt = a[4:0];

    // flag is tri-state: '1' for SLT/SLTU, 'z' otherwise
    assign flag = (aluc == SLT)  ? (( $signed(a) < $signed(b)) ? 1'b1 : 1'b0) :
                  (aluc == SLTU) ? ((a < b) ? 1'b1 : 1'b0) : 1'bz;

    always @(*) begin
        // defaults
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;

        case (aluc)
            ADD: begin
                // signed addition
                r = $signed(a) + $signed(b);
                // overflow if signs of a and b same, but result sign differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                carry = 1'b0; // carry not meaningful for signed add
            end
            ADDU: begin
                {carry, r} = a + b;
                overflow = 1'b0;
            end
            SUB: begin
                // signed subtraction
                r = $signed(a) - $signed(b);
                // overflow if signs differ between a and b and result sign differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                carry = 1'b0;
            end
            SUBU: begin
                // unsigned subtraction
                {carry, r} = a - b;
                overflow = 1'b0;
                // carry indicates borrow in subtraction, invert to reflect 'carry occurred' properly
                // Alternative: carry = ~borrow, but more intuitive to set carry = ~carry_in from subtraction
                // For clarity, implement borrow detection explicitly:
                carry = (a < b) ? 1'b1 : 1'b0;
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
                // signed compare; set r = 1 or 0
                r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                // flag assigned by continuous assign above
            end
            SLTU: begin
                // unsigned compare
                r = (a < b) ? 32'd1 : 32'd0;
                // flag assigned by continuous assign above
            end
            SLL: begin
                // logical left shift by shamt in a[4:0]
                r = b << shamt;
            end
            SRL: begin
                r = b >> shamt;
            end
            SRA: begin
                r = $signed(b) >>> shamt;
            end
            SLLV: begin
                // shift amount is lower 5 bits of a
                r = b << shamt;
            end
            SRLV: begin
                r = b >> shamt;
            end
            SRAV: begin
                r = $signed(b) >>> shamt;
            end
            LUI: begin
                // upper 16 bits of a concatenated with 16 zeros per spec
                r = {a[31:16], 16'b0};
            end
            default: begin
                // assign high impedance to r to reflect unknown
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];
endmodule