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

    // Signed views
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Arithmetic Unit: handles ADD, ADDU, SUB, SUBU
    reg [32:0] arith_sum;
    reg [31:0] arith_result;
    reg arith_carry;
    reg arith_overflow;

    always @(*) begin
        case (aluc)
            ADD: begin
                arith_sum = {1'b0, a} + {1'b0, b};
                arith_carry = arith_sum[32];
                arith_result = arith_sum[31:0];
                // Overflow detection for signed add
                arith_overflow = (~a[31] & ~b[31] & arith_result[31]) | (a[31] & b[31] & ~arith_result[31]);
            end
            ADDU: begin
                arith_sum = {1'b0, a} + {1'b0, b};
                arith_carry = arith_sum[32];
                arith_result = arith_sum[31:0];
                arith_overflow = 1'b0;
            end
            SUB: begin
                arith_sum = {1'b0, a} - {1'b0, b};
                arith_carry = arith_sum[32];
                arith_result = arith_sum[31:0];
                // Overflow detection for signed sub
                arith_overflow = (a[31] & ~b[31] & ~arith_result[31]) | (~a[31] & b[31] & arith_result[31]);
            end
            SUBU: begin
                arith_sum = {1'b0, a} - {1'b0, b};
                arith_carry = arith_sum[32];
                arith_result = arith_sum[31:0];
                arith_overflow = 1'b0;
            end
            default: begin
                arith_sum = 33'd0;
                arith_carry = 1'b0;
                arith_result = 32'd0;
                arith_overflow = 1'b0;
            end
        endcase
    end

    // Logic Unit: AND, OR, XOR, NOR
    reg [31:0] logic_result;
    always @(*) begin
        case (aluc)
            AND: logic_result = a & b;
            OR:  logic_result = a | b;
            XOR: logic_result = a ^ b;
            NOR: logic_result = ~(a | b);
            default: logic_result = 32'd0;
        endcase
    end

    // Shift Unit: SLL, SRL, SRA, SLLV, SRLV, SRAV
    // Shift amounts
    wire [4:0] shamt_fixed = b[4:0]; // For fixed shifts, shift amount comes from b[4:0]
    wire [4:0] shamt_var   = a[4:0]; // For variable shifts, from a[4:0]
    reg [31:0] shift_result;

    always @(*) begin
        case(aluc)
            SLL:  shift_result = b << shamt_fixed;
            SRL:  shift_result = b >> shamt_fixed;
            SRA:  shift_result = $signed(b_s) >>> shamt_fixed;
            SLLV: shift_result = b << shamt_var;
            SRLV: shift_result = b >> shamt_var;
            SRAV: shift_result = $signed(b_s) >>> shamt_var;
            default: shift_result = 32'd0;
        endcase
    end

    // Comparison Unit: SLT and SLTU
    reg cmp_flag;
    reg [31:0] cmp_result;
    always @(*) begin
        case (aluc)
            SLT: begin
                cmp_flag = (a_s < b_s) ? 1'b1 : 1'b0;
                cmp_result = {31'd0, cmp_flag};
            end
            SLTU: begin
                cmp_flag = (a < b) ? 1'b1 : 1'b0;
                cmp_result = {31'd0, cmp_flag};
            end
            default: begin
                cmp_flag = 1'b0;
                cmp_result = 32'd0;
            end
        endcase
    end

    // LUI operation
    wire [31:0] lui_result = {a[15:0], 16'b0};

    // Result Multiplexer and flags assignment
    always @(*) begin
        // Default outputs
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = arith_result;
                carry = arith_carry;
                overflow = arith_overflow;
                flag = 1'b0;
            end
            AND, OR, XOR, NOR: begin
                r = logic_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SLT, SLTU: begin
                r = cmp_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = cmp_flag;
            end
            SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
                r = shift_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            LUI: begin
                r = lui_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            default: begin
                r = 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase

        zero = (r == 32'd0) ? 1'b1 : 1'b0;
        negative = r[31];
    end

endmodule