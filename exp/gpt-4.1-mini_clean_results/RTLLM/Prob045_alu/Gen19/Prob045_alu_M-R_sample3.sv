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

    // Opcode parameters
    localparam ADD  = 6'b100000;
    localparam ADDU = 6'b100001;
    localparam SUB  = 6'b100010;
    localparam SUBU = 6'b100011;
    localparam AND  = 6'b100100;
    localparam OR   = 6'b100101;
    localparam XOR  = 6'b100110;
    localparam NOR  = 6'b100111;
    localparam SLT  = 6'b101010;
    localparam SLTU = 6'b101011;
    localparam SLL  = 6'b000000;
    localparam SRL  = 6'b000010;
    localparam SRA  = 6'b000011;
    localparam SLLV = 6'b000100;
    localparam SRLV = 6'b000110;
    localparam SRAV = 6'b000111;
    localparam LUI  = 6'b001111;

    // Signed versions of inputs for arithmetic and comparisons
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Shift amount from a[4:0]
    wire [4:0] shamt = a[4:0];

    // Internal variables for arithmetic extended results and flags
    reg [32:0] arith_ext;
    reg arith_overflow;
    reg arith_carry;
    reg slt_flag_val;

    always @(*) begin
        // Default assignments
        r = 32'b0;
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            // ADD signed
            ADD: begin
                arith_ext = {a[31], a} + {b[31], b};
                r = arith_ext[31:0];
                arith_carry = arith_ext[32];
                // Overflow detection for signed add
                arith_overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                carry = arith_carry;
                overflow = arith_overflow;
            end

            // ADD unsigned
            ADDU: begin
                arith_ext = {1'b0, a} + {1'b0, b};
                r = arith_ext[31:0];
                carry = arith_ext[32];
                overflow = 1'b0;
            end

            // SUB signed
            SUB: begin
                arith_ext = {a[31], a} - {b[31], b};
                r = arith_ext[31:0];
                arith_carry = ~arith_ext[32];
                // Overflow detection for signed sub
                arith_overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                carry = arith_carry;
                overflow = arith_overflow;
            end

            // SUB unsigned
            SUBU: begin
                arith_ext = {1'b0, a} - {1'b0, b};
                r = arith_ext[31:0];
                carry = ~arith_ext[32];
                overflow = 1'b0;
            end

            // Logical operations
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);

            // Set less than signed
            SLT: begin
                slt_flag_val = (a_s < b_s);
                r = slt_flag_val ? 32'd1 : 32'd0;
                flag = slt_flag_val;
            end

            // Set less than unsigned
            SLTU: begin
                slt_flag_val = (a < b);
                r = slt_flag_val ? 32'd1 : 32'd0;
                flag = slt_flag_val;
            end

            // Shift operations with fixed shift amount (from a[4:0])
            SLL:  r = b << shamt;
            SRL:  r = b >> shamt;
            SRA:  r = $signed(b) >>> shamt;

            // Shift operations with variable shift amount (from a[4:0])
            SLLV: r = b << shamt;
            SRLV: r = b >> shamt;
            SRAV: r = $signed(b) >>> shamt;

            // Load upper immediate: a[15:0] << 16
            LUI:  r = {a[15:0], 16'b0};

            default: begin
                r = 32'bz; // High-impedance for undefined opcodes
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase

        // Flags that depend on r
        zero = (r == 32'b0);
        negative = r[31];
        // Note: carry and overflow already assigned where needed
    end

endmodule