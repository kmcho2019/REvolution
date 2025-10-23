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

// Opcodes
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

// Signed versions for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts
wire [4:0] shamt = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Arithmetic operations intermediate signals
reg [32:0] arith_full;
reg [31:0] arith_res;
reg        arith_carry;
reg        arith_overflow;

// Logic operations intermediate signals
reg [31:0] logic_res;

// Shift operations intermediate signals
reg [31:0] shift_res;

// LUI intermediate signal
wire [31:0] lui_res = {a[15:0], 16'b0};

// SLT and SLTU flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res  = slt_flag  ? 32'b1 : 32'b0;
wire [31:0] sltu_res = sltu_flag ? 32'b1 : 32'b0;

always @(*) begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag = 1'bz; // per spec, only driven for SLT/SLTU

    // Arithmetic calculations for ADD, ADDU, SUB, SUBU
    arith_full = 33'b0;
    arith_res = 32'b0;
    arith_carry = 1'b0;
    arith_overflow = 1'b0;

    case (aluc)
        ADD: begin
            arith_full = {1'b0, a} + {1'b0, b};
            arith_res = arith_full[31:0];
            arith_carry = arith_full[32];
            // overflow: if same sign inputs and result sign different
            arith_overflow = (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]);
            r = arith_res;
            carry = arith_carry;
            overflow = arith_overflow;
            negative = arith_res[31];
            flag = 1'b0;
        end
        ADDU: begin
            arith_full = {1'b0, a} + {1'b0, b};
            arith_res = arith_full[31:0];
            arith_carry = arith_full[32];
            r = arith_res;
            carry = arith_carry;
            overflow = 1'b0;
            negative = arith_res[31];
            flag = 1'b0;
        end
        SUB: begin
            arith_full = {1'b0, a} - {1'b0, b};
            arith_res = arith_full[31:0];
            arith_carry = arith_full[32]; // borrow not set if 1
            // overflow for signed subtraction
            arith_overflow = (a[31] & ~b[31] & ~arith_res[31]) | (~a[31] & b[31] & arith_res[31]);
            r = arith_res;
            carry = arith_carry;
            overflow = arith_overflow;
            negative = arith_res[31];
            flag = 1'b0;
        end
        SUBU: begin
            arith_full = {1'b0, a} - {1'b0, b};
            arith_res = arith_full[31:0];
            arith_carry = arith_full[32];
            r = arith_res;
            carry = arith_carry;
            overflow = 1'b0;
            negative = arith_res[31];
            flag = 1'b0;
        end
        AND, OR, XOR, NOR: begin
            // Logic ops
            case(aluc)
                AND: logic_res = a & b;
                OR:  logic_res = a | b;
                XOR: logic_res = a ^ b;
                NOR: logic_res = ~(a | b);
                default: logic_res = 32'b0;
            endcase
            r = logic_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = logic_res[31];
            flag = 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            case(aluc)
                SLL:  shift_res = b << shamt;
                SRL:  shift_res = b >> shamt;
                SRA:  shift_res = $signed(b_s) >>> shamt;
                SLLV: shift_res = b << shamt_var;
                SRLV: shift_res = b >> shamt_var;
                SRAV: shift_res = $signed(b_s) >>> shamt_var;
                default: shift_res = 32'b0;
            endcase
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = shift_res[31];
            flag = 1'b0;
        end
        LUI: begin
            r = lui_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = lui_res[31];
            flag = 1'b0;
        end
        SLT: begin
            r = slt_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = slt_res[31];
            flag = 1'b1;
        end
        SLTU: begin
            r = sltu_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = sltu_res[31];
            flag = 1'b1;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'bz;
        end
    endcase
end

assign zero = (r == 32'b0);

endmodule