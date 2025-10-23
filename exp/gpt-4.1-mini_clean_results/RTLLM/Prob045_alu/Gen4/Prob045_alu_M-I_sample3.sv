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

// Define opcodes as parameters
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
wire [4:0] shamt_var = a[4:0]; // Same as shamt_fixed, kept for clarity

reg [31:0] result;
reg carry_tmp;
reg overflow_tmp;
reg flag_tmp;

always @(*) begin
    // Defaults
    result = 32'b0;
    carry_tmp = 1'b0;
    overflow_tmp = 1'b0;
    flag_tmp = 1'b0;

    case(aluc)
        ADD: begin
            {carry_tmp, result} = {1'b0, a} + {1'b0, b};
            // Signed overflow detection
            overflow_tmp = (~a[31] & ~b[31] & result[31]) | (a[31] & b[31] & ~result[31]);
        end
        ADDU: begin
            {carry_tmp, result} = {1'b0, a} + {1'b0, b};
            overflow_tmp = 1'b0;
        end
        SUB: begin
            {carry_tmp, result} = {1'b0, a} - {1'b0, b};
            // borrow = ~carry_tmp in unsigned; for carry flag as borrow inverted
            // For MIPS carry flag in subtraction is borrow inverted (1 means no borrow)
            carry_tmp = (a >= b);
            // Signed overflow detection
            overflow_tmp = (a[31] & ~b[31] & ~result[31]) | (~a[31] & b[31] & result[31]);
        end
        SUBU: begin
            {carry_tmp, result} = {1'b0, a} - {1'b0, b};
            carry_tmp = (a >= b);
            overflow_tmp = 1'b0;
        end
        AND: begin
            result = a & b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end
        OR: begin
            result = a | b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end
        XOR: begin
            result = a ^ b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end
        NOR: begin
            result = ~(a | b);
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end
        SLT: begin
            flag_tmp = (a_s < b_s);
            result = {31'b0, flag_tmp};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end
        SLTU: begin
            flag_tmp = (a < b);
            result = {31'b0, flag_tmp};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end

        // Shift operations merged to reduce redundancy
        SLL,
        SLLV: begin
            // Shift amount depends on instruction
            // For SLL: shift amount = a[4:0] (fixed shamt), for SLLV: shift amount = a[4:0] variable shift
            // For SLL, shamt is actually from instruction encoding; here a[4:0]
            // Use variable shift amount accordingly
            result = b << ((aluc == SLL) ? shamt_fixed : shamt_var);
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end

        SRL,
        SRLV: begin
            result = b >> ((aluc == SRL) ? shamt_fixed : shamt_var);
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end

        SRA,
        SRAV: begin
            result = $signed(b_s) >>> ((aluc == SRA) ? shamt_fixed : shamt_var);
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end

        LUI: begin
            // Load upper immediate: b's lower 16 bits shifted to upper 16 bits
            result = {b[15:0], 16'b0};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
        end

        default: begin
            result = 32'b0;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
    endcase

    // Assign outputs
    r = result;
    zero = (result == 32'b0);
    negative = result[31];
    carry = carry_tmp;
    overflow = overflow_tmp;
    // Flag only valid for SLT and SLTU, else zero
    if ((aluc == SLT) || (aluc == SLTU))
        flag = flag_tmp;
    else
        flag = 1'b0;
end

endmodule