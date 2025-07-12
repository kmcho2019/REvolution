module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output wire        flag
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

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount extraction
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// 33-bit intermediate for arithmetic (to detect carry out)
reg [32:0] arith_result;

// For detecting overflow in addition and subtraction
reg add_overflow_flag, sub_overflow_flag;

// Flag output only valid for SLT and SLTU; otherwise, high impedance
assign flag = (aluc == SLT)  ? (a_s < b_s) :
              (aluc == SLTU) ? (a < b)    : 1'bz;

// Zero flag: set when r == 0
assign zero = (r == 32'b0);

always @(*) begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    arith_result = 33'b0;
    add_overflow_flag = 1'b0;
    sub_overflow_flag = 1'b0;

    case (aluc)
        // ADD signed
        ADD: begin
            arith_result = {a[31], a} + {b[31], b};
            r = arith_result[31:0];
            carry = arith_result[32];
            // Overflow: sign changed unexpectedly
            add_overflow_flag = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            overflow = add_overflow_flag;
        end

        // ADD unsigned
        ADDU: begin
            arith_result = {1'b0, a} + {1'b0, b};
            r = arith_result[31:0];
            carry = arith_result[32];
            overflow = 1'b0;
        end

        // SUB signed
        SUB: begin
            arith_result = {a[31], a} - {b[31], b};
            r = arith_result[31:0];
            carry = arith_result[32];
            // Overflow for subtraction
            sub_overflow_flag = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            overflow = sub_overflow_flag;
        end

        // SUB unsigned
        SUBU: begin
            arith_result = {1'b0, a} - {1'b0, b};
            r = arith_result[31:0];
            carry = arith_result[32];
            overflow = 1'b0;
        end

        // AND
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // OR
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // XOR
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // NOR
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SLT (set on less than signed)
        SLT: begin
            r = (a_s < b_s) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SLTU (set on less than unsigned)
        SLTU: begin
            r = (a < b) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SLL (shift left logical immediate)
        SLL: begin
            r = b << shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SRL (shift right logical immediate)
        SRL: begin
            r = b >> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SRA (shift right arithmetic immediate)
        SRA: begin
            r = $signed(b_s) >>> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SLLV (shift left logical variable)
        SLLV: begin
            r = b << shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SRLV (shift right logical variable)
        SRLV: begin
            r = b >> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // SRAV (shift right arithmetic variable)
        SRAV: begin
            r = $signed(b_s) >>> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end

        // LUI (load upper immediate)
        LUI: begin
            r = {a[31:16], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
        end

        // Default: high impedance output
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase

    // Negative flag from result MSB
    negative = r[31];
end

endmodule