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

wire [4:0] shamt_fixed = a[4:0];    // Shift amount for fixed shifts (SLL, SRL, SRA)
wire [4:0] shamt_var   = a[4:0];    // Shift amount for variable shifts (SLLV, SRLV, SRAV)

wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Extended arithmetic for carry detection
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

always @(*) begin
    // Defaults to avoid latches and minimize toggling
    r = 32'b0;
    carry = 1'b0;      // Only meaningful for arithmetic operations
    overflow = 1'b0;   // Only meaningful for arithmetic operations
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        // Signed add with overflow and carry
        ADD: begin
            {carry, r} = add_ext;
            // Overflow: sign of a and b same, sign of r differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        // Unsigned add with carry, no overflow
        ADDU: begin
            {carry, r} = add_ext;
            overflow = 1'b0;
        end
        // Signed sub with overflow and carry
        SUB: begin
            {carry, r} = sub_ext;
            // Overflow: signs of a and b differ, and sign of r differs from a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        // Unsigned sub with carry, no overflow
        SUBU: begin
            {carry, r} = sub_ext;
            overflow = 1'b0;
        end

        // Logical operations: no carry or overflow
        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);

        // Set on less than (signed)
        SLT: begin
            flag = (a_s < b_s);
            r = {31'b0, flag};
        end
        // Set on less than (unsigned)
        SLTU: begin
            flag = (a < b);
            r = {31'b0, flag};
        end

        // Fixed shift left logical: shift b by a[4:0]
        SLL: r = b << shamt_fixed;
        // Fixed shift right logical: shift b by a[4:0]
        SRL: r = b >> shamt_fixed;
        // Fixed shift right arithmetic: shift b signed by a[4:0]
        SRA: r = b_s >>> shamt_fixed;

        // Variable shift left logical: shift b by a[4:0]
        SLLV: r = b << shamt_var;
        // Variable shift right logical: shift b by a[4:0]
        SRLV: r = b >> shamt_var;
        // Variable shift right arithmetic: shift b signed by a[4:0]
        SRAV: r = b_s >>> shamt_var;

        // Load upper immediate: MIPS standard is loading b's lower 16 bits into upper half of r
        // Here we implement LUI as b << 16 to match standard behavior
        LUI: r = b << 16;

        // Default: zero outputs and cleared flags
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    // Negative flag always based on r[31]
    negative = r[31];
end

// Zero flag continuously assigned for synthesis clarity and avoiding glitches
assign zero = (r == 32'b0);

endmodule