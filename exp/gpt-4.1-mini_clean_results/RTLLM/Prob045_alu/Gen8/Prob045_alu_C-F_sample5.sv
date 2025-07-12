module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Opcode definitions
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

// Signed versions of inputs for signed ops
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount uses a[4:0] consistent across shifts
wire [4:0] shamt = a[4:0];

always @* begin
    // Default assignments to avoid latches and minimize toggling
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    flag     = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            // Overflow for signed addition: 
            // If a and b have same sign but result sign differs, overflow occurs.
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            // Unsigned add has no overflow
        end
        SUB: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            // Overflow for signed subtraction:
            // If a and b have different signs and result sign differs from a's sign, overflow occurs.
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            // Unsigned subtraction no overflow
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
            // Signed comparison
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            // Unsigned comparison
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL: begin
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = $signed(b_s) >>> shamt;
        end
        SLLV: begin
            r = b << a[4:0];
        end
        SRLV: begin
            r = b >> a[4:0];
        end
        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
        end
        LUI: begin
            // LUI loads the immediate (b) shifted left by 16 bits (upper 16 bits)
            // Since typical MIPS LUI instruction loads 16-bit immediate into upper half
            r = b << 16;
        end
        default: begin
            // Unknown opcode: result and flags zero (could assign 'z' if required)
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule