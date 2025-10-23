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

    // Intermediate signals
    reg [31:0] arith_res;
    reg [32:0] arith_ext; // 33 bits for carry/borrow detection
    reg        arith_carry;
    reg        arith_overflow;
    reg [31:0] logic_res;
    reg [31:0] shift_res;
    reg        slt_flag;
    reg [31:0] slt_res;

    wire [4:0] shamt = a[4:0];       // For fixed shifts (SLL, SRL, SRA)
    wire [4:0] shamt_var = a[4:0];   // For variable shifts (SLLV, SRLV, SRAV)

    // Arithmetic operations
    always @(*) begin
        case (aluc)
            ADD:  arith_ext = {1'b0, a} + {1'b0, b};
            ADDU: arith_ext = {1'b0, a} + {1'b0, b};
            SUB:  arith_ext = {1'b0, a} - {1'b0, b};
            SUBU: arith_ext = {1'b0, a} - {1'b0, b};
            default: arith_ext = 33'd0;
        endcase
    end

    always @(*) begin
        arith_res = arith_ext[31:0];
        arith_carry = arith_ext[32];
        // Overflow detection for signed add/sub
        case (aluc)
            ADD:  arith_overflow = (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]);
            SUB:  arith_overflow = (a[31] & ~b[31] & ~arith_res[31]) | (~a[31] & b[31] & arith_res[31]);
            default: arith_overflow = 1'b0;
        endcase
    end

    // Logical operations
    always @(*) begin
        case (aluc)
            AND: logic_res = a & b;
            OR:  logic_res = a | b;
            XOR: logic_res = a ^ b;
            NOR: logic_res = ~(a | b);
            default: logic_res = 32'd0;
        endcase
    end

    // Shift operations
    always @(*) begin
        case (aluc)
            SLL:  shift_res = b << shamt;
            SRL:  shift_res = b >> shamt;
            SRA:  shift_res = $signed(b) >>> shamt;
            SLLV: shift_res = b << shamt_var;
            SRLV: shift_res = b >> shamt_var;
            SRAV: shift_res = $signed(b) >>> shamt_var;
            default: shift_res = 32'd0;
        endcase
    end

    // SLT and SLTU computation
    always @(*) begin
        case (aluc)
            SLT: begin
                slt_flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
                slt_res = slt_flag ? 32'd1 : 32'd0;
            end
            SLTU: begin
                slt_flag = (a < b) ? 1'b1 : 1'b0;
                slt_res = slt_flag ? 32'd1 : 32'd0;
            end
            default: begin
                slt_flag = 1'bz;
                slt_res = 32'd0;
            end
        endcase
    end

    // LUI operation: upper 16 bits from a[15:0], lower 16 bits zero
    wire [31:0] lui_res = {a[15:0], 16'b0};

    // Output multiplexer
    always @(*) begin
        // Default outputs
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        flag = 1'bz;

        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = arith_res;
                carry = arith_carry;
                overflow = arith_overflow;
            end
            AND, OR, XOR, NOR: begin
                r = logic_res;
            end
            SLT, SLTU: begin
                r = slt_res;
                flag = slt_flag;
            end
            SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
                r = shift_res;
            end
            LUI: begin
                r = lui_res;
            end
            default: begin
                r = 32'd0;       // Safe default: no high-Z on result
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase

        negative = r[31];
    end

    assign zero = (r == 32'd0);

endmodule