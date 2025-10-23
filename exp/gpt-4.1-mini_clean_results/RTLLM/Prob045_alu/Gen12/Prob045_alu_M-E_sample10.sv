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

// Signed versions for arithmetic and comparison
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts (from lower 5 bits)
wire [4:0] shamt = a[4:0];
wire [4:0] shamt_var = a[4:0];

// --- Adder / Subtractor Unit ---
reg [32:0] sum_ext;  // 33-bit for carry detection
reg [31:0] adder_out;
reg        adder_carry;
reg        adder_overflow;

always @* begin
    adder_out = 32'b0;
    adder_carry = 1'b0;
    adder_overflow = 1'b0;
    case(aluc)
        ADD: begin
            sum_ext = {1'b0, a} + {1'b0, b};
            adder_out = sum_ext[31:0];
            adder_carry = sum_ext[32];
            // Overflow detection for signed addition:
            // If a and b have same sign, but result differs in sign, overflow
            adder_overflow = (~a[31] & ~b[31] & adder_out[31]) | (a[31] & b[31] & ~adder_out[31]);
        end
        ADDU: begin
            sum_ext = {1'b0, a} + {1'b0, b};
            adder_out = sum_ext[31:0];
            adder_carry = sum_ext[32];
            adder_overflow = 1'b0; // no overflow for unsigned add
        end
        SUB: begin
            sum_ext = {1'b0, a} - {1'b0, b};
            adder_out = sum_ext[31:0];
            // In subtraction, carry flag set to NOT borrow (i.e. if no borrow, carry=1)
            adder_carry = ~sum_ext[32];
            // Overflow detection for signed subtraction:
            // If signs of a and b differ and result sign differs from a sign, overflow
            adder_overflow = (a[31] & ~b[31] & ~adder_out[31]) | (~a[31] & b[31] & adder_out[31]);
        end
        SUBU: begin
            sum_ext = {1'b0, a} - {1'b0, b};
            adder_out = sum_ext[31:0];
            adder_carry = ~sum_ext[32];
            adder_overflow = 1'b0;
        end
        default: begin
            adder_out = 32'b0;
            adder_carry = 1'b0;
            adder_overflow = 1'b0;
        end
    endcase
end

// --- Logic Unit ---
reg [31:0] logic_out;
always @* begin
    case(aluc)
        AND: logic_out = a & b;
        OR : logic_out = a | b;
        XOR: logic_out = a ^ b;
        NOR: logic_out = ~(a | b);
        default: logic_out = 32'b0;
    endcase
end

// --- Shift Unit ---
reg [31:0] shift_out;
always @* begin
    case(aluc)
        SLL:  shift_out = b << shamt;
        SRL:  shift_out = b >> shamt;
        SRA:  shift_out = $signed(b_s) >>> shamt;
        SLLV: shift_out = b << shamt_var;
        SRLV: shift_out = b >> shamt_var;
        SRAV: shift_out = $signed(b_s) >>> shamt_var;
        default: shift_out = 32'b0;
    endcase
end

// --- Comparator Unit for SLT / SLTU ---
reg cmp_flag;
reg [31:0] cmp_out;
always @* begin
    cmp_flag = 1'b0;
    cmp_out = 32'b0;
    case(aluc)
        SLT: begin
            cmp_flag = (a_s < b_s) ? 1'b1 : 1'b0;
            cmp_out = {31'b0, cmp_flag};
        end
        SLTU: begin
            cmp_flag = (a < b) ? 1'b1 : 1'b0;
            cmp_out = {31'b0, cmp_flag};
        end
    endcase
end

// --- LUI Unit ---
reg [31:0] lui_out;
always @* begin
    if (aluc == LUI)
        lui_out = {b[15:0],16'b0}; // LUI typically loads b's lower 16 bits into upper half
    else
        lui_out = 32'b0;
end

// --- Output Selection ---
always @* begin
    r = 32'bz;  // default high impedance if unknown operation
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;
    negative = 1'b0;
    zero = 1'b0;

    case(aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = adder_out;
            carry = adder_carry;
            overflow = adder_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logic_out;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_out;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT, SLTU: begin
            r = cmp_out;
            flag = cmp_flag;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = lui_out;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    negative = r[31];
    zero = (r == 32'b0);
    // flag remains 'z' for all except SLT/SLTU
end

endmodule