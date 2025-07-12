module alu (
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

    // Define opcodes
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

    // Intermediate signed and unsigned operands
    wire signed [31:0] a_signed = $signed(a);
    wire signed [31:0] b_signed = $signed(b);

    // Shift amount extraction: 
    // For fixed shift instructions (SLL, SRL, SRA) use a[4:0] as shift amount,
    // for variable shifts (SLLV, SRLV, SRAV) use a[4:0] as shift amount.
    wire [4:0] shamt_fixed = a[4:0];
    wire [4:0] shamt_var   = a[4:0];

    // Internal registers for addition/subtraction with carry
    reg [32:0] sum;          // 33-bit for carry detection
    reg [31:0] logic_result;
    reg [31:0] shift_result;
    reg        carry_out;
    reg        ovf;

    // Define operation category signals
    wire is_add  = (aluc == ADD)  || (aluc == ADDU);
    wire is_sub  = (aluc == SUB)  || (aluc == SUBU);
    wire is_logic = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire is_slt  = (aluc == SLT)  || (aluc == SLTU);
    wire is_shift_fixed = (aluc == SLL) || (aluc == SRL) || (aluc == SRA);
    wire is_shift_var   = (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_lui = (aluc == LUI);

    // Helper signals for addition/subtraction
    wire [31:0] b_neg = ~b + 1;  // Two's complement negation of b for subtraction

    always @* begin
        // Default signal assignments
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        zero = 1'b0;
        flag = 1'b0;
        sum = 33'd0;
        logic_result = 32'd0;
        shift_result = 32'd0;
        carry_out = 1'b0;
        ovf = 1'b0;

        // Arithmetic: ADD and SUB share adder logic, handle signed and unsigned versions
        if (is_add || is_sub) begin
            // For subtraction, add a + (~b + 1)
            if (is_add) begin
                sum = {1'b0, a} + {1'b0, b};
            end else begin
                sum = {1'b0, a} + {1'b0, (~b) + 1'b1};
            end
            r = sum[31:0];

            // carry flag meaningful only for unsigned add/sub
            if (aluc == ADDU) carry_out = sum[32];
            else if (aluc == SUBU) carry_out = (a >= b) ? 1'b1 : 1'b0;
            else carry_out = 1'b0;

            carry = carry_out;

            // Overflow detection only for signed add/sub
            // Overflow if sign(a) == sign(b) and sign(result) != sign(a) for addition
            // For subtraction: overflow if sign(a) != sign(b) and sign(result) != sign(a)
            if (aluc == ADD) begin
                ovf = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end else if (aluc == SUB) begin
                ovf = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end else begin
                ovf = 1'b0;
            end
            overflow = ovf;

            negative = r[31];
        end
        // Logic operations
        else if (is_logic) begin
            case (aluc)
                AND: logic_result = a & b;
                OR:  logic_result = a | b;
                XOR: logic_result = a ^ b;
                NOR: logic_result = ~(a | b);
                default: logic_result = 32'd0;
            endcase
            r = logic_result;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        // Set on Less Than operations
        else if (is_slt) begin
            if (aluc == SLT) begin
                // Signed comparison
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            end else if (aluc == SLTU) begin
                // Unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
            end
            r = {31'd0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        // Shift fixed amount (shamt_fixed)
        else if (is_shift_fixed) begin
            case (aluc)
                SLL: shift_result = b << shamt_fixed;
                SRL: shift_result = b >> shamt_fixed;
                SRA: shift_result = $signed(b_signed) >>> shamt_fixed;
                default: shift_result = 32'd0;
            endcase
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        // Shift variable amount (shamt_var = a[4:0])
        else if (is_shift_var) begin
            case (aluc)
                SLLV: shift_result = b << shamt_var;
                SRLV: shift_result = b >> shamt_var;
                SRAV: shift_result = $signed(b_signed) >>> shamt_var;
                default: shift_result = 32'd0;
            endcase
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        // LUI: Load upper immediate (a[15:0] in upper 16 bits, lower bits zero)
        else if (is_lui) begin
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        // Default: output zero
        else begin
            r = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'b0;
        end

        zero = (r == 32'd0) ? 1'b1 : 1'b0;

        // For operations other than SLT/SLTU, flag is 0
        if (!(aluc == SLT || aluc == SLTU))
            flag = 1'b0;
    end

endmodule