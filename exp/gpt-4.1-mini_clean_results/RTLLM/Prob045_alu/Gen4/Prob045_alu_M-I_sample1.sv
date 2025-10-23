module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire zero,
    output reg  carry,
    output reg  negative,
    output reg  overflow,
    output reg  flag
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

    // Extract shift amount from 'a' (lowest 5 bits)
    wire [4:0] shamt = a[4:0];

    // Signed versions for arithmetic and comparison
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Intermediate variables for arithmetic
    reg signed [32:0] sum_signed;  // 33 bits to capture carry out
    reg [32:0]        sum_unsigned;
    reg               carry_calc;
    reg               overflow_calc;
    reg               flag_calc;

    always @(*) begin
        // Default outputs
        r        = 32'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        flag     = 1'b0;
        negative = 1'b0;

        case (aluc)
            // Signed addition with overflow detection
            ADD: begin
                sum_signed = {a_s[31], a_s} + {b_s[31], b_s};
                r = sum_signed[31:0];
                carry = 1'b0; // carry is not meaningful for signed addition here
                // Overflow when sign of a == sign of b but sign of result differs
                overflow = (~a_s[31] & ~b_s[31] & r[31]) | (a_s[31] & b_s[31] & ~r[31]);
            end

            // Unsigned addition with carry, no overflow
            ADDU: begin
                sum_unsigned = {1'b0, a} + {1'b0, b};
                r = sum_unsigned[31:0];
                carry = sum_unsigned[32];
                overflow = 1'b0;
            end

            // Signed subtraction with overflow detection
            SUB: begin
                sum_signed = {a_s[31], a_s} - {b_s[31], b_s};
                r = sum_signed[31:0];
                carry = 1'b0; // carry unused
                // Overflow occurs if sign of a != sign of b and sign of result != sign of a
                overflow = (~a_s[31] & b_s[31] & r[31]) | (a_s[31] & ~b_s[31] & ~r[31]);
            end

            // Unsigned subtraction with borrow detection
            SUBU: begin
                sum_unsigned = {1'b0, a} - {1'b0, b};
                r = sum_unsigned[31:0];
                // borrow = ~carry_out from subtraction
                carry = ~sum_unsigned[32];
                overflow = 1'b0;
            end

            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);

            // Set Less Than - signed
            SLT: begin
                flag_calc = (a_s < b_s);
                flag = flag_calc;
                r = flag_calc ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
            end

            // Set Less Than - unsigned
            SLTU: begin
                flag_calc = (a < b);
                flag = flag_calc;
                r = flag_calc ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
            end

            // Shift operations - fixed amount
            SLL:  r = b << shamt;
            SRL:  r = b >> shamt;
            SRA:  r = $signed(b) >>> shamt;

            // Shift operations - variable amount (using a[4:0])
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = $signed(b) >>> a[4:0];

            // Load Upper Immediate
            LUI:  r = {a[31:16], 16'b0};

            // Default for undefined opcodes: output zeros and clear flags
            default: begin
                r        = 32'b0;
                carry    = 1'b0;
                overflow = 1'b0;
                flag     = 1'b0;
            end
        endcase

        // Negative flag is MSB of result
        negative = r[31];
    end

    // Zero flag combinational
    assign zero = (r == 32'b0);

endmodule