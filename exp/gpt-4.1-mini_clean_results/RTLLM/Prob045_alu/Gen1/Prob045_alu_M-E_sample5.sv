module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
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

// Signed versions for signed operations
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Shift amounts extracted
wire [4:0] shamt_imm = a[4:0]; // shift amount from a[4:0] for fixed shifts
wire [4:0] shamt_var = a[4:0]; // variable shift amount same as above per spec

// Arithmetic results and flags
wire [32:0] add_full;
wire [32:0] addu_full;
wire [32:0] sub_full;
wire [32:0] subu_full;

// Signed addition (ADD)
assign add_full = {a_signed[31], a_signed} + {b_signed[31], b_signed};
// Unsigned addition (ADDU)
assign addu_full = {1'b0, a} + {1'b0, b};
// Signed subtraction (SUB)
assign sub_full = {a_signed[31], a_signed} - {b_signed[31], b_signed};
// Unsigned subtraction (SUBU)
assign subu_full = {1'b0, a} - {1'b0, b};

// Logical and shift results
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

wire [31:0] sll_res  = b << shamt_imm;
wire [31:0] srl_res  = b >> shamt_imm;
wire [31:0] sra_res  = $signed(b) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b) >>> shamt_var;

wire [31:0] lui_res = {b[15:0],16'b0};

// SLT and SLTU flags and result
wire slt_flag = (a_signed < b_signed);
wire sltu_flag = (a < b);

// Default outputs
reg [31:0] res;
reg carry_out;
reg overflow_out;
reg flag_out;

always @(*) begin
    // Defaults
    res = 32'b0;
    carry_out = 1'b0;
    overflow_out = 1'b0;
    flag_out = 1'b0;

    case (aluc)
        ADD: begin
            res = add_full[31:0];
            carry_out = add_full[32];
            // Overflow occurs if sign of operands is same and sign of result differs
            overflow_out = ((a_signed[31] == b_signed[31]) && (res[31] != a_signed[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            res = addu_full[31:0];
            carry_out = addu_full[32];
            overflow_out = 1'b0; // No overflow in unsigned addition
        end
        SUB: begin
            res = sub_full[31:0];
            // For carry in subtraction: carry=1 if no borrow (a >= b unsigned)
            carry_out = (a >= b) ? 1'b1 : 1'b0;
            // Overflow if signs of operands differ and sign of result differs from a
            overflow_out = ((a_signed[31] != b_signed[31]) && (res[31] != a_signed[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            res = subu_full[31:0];
            carry_out = (a >= b) ? 1'b1 : 1'b0; // carry means no borrow
            overflow_out = 1'b0;
        end
        AND: begin
            res = and_res;
        end
        OR: begin
            res = or_res;
        end
        XOR: begin
            res = xor_res;
        end
        NOR: begin
            res = nor_res;
        end
        SLT: begin
            flag_out = slt_flag;
            res = 32'b0;
            res[0] = slt_flag;
        end
        SLTU: begin
            flag_out = sltu_flag;
            res = 32'b0;
            res[0] = sltu_flag;
        end
        SLL: begin
            res = sll_res;
        end
        SRL: begin
            res = srl_res;
        end
        SRA: begin
            res = sra_res;
        end
        SLLV: begin
            res = sllv_res;
        end
        SRLV: begin
            res = srlv_res;
        end
        SRAV: begin
            res = srav_res;
        end
        LUI: begin
            res = lui_res;
        end
        default: begin
            // For unknown opcode, output zero and clear flags
            res = 32'b0;
            carry_out = 1'b0;
            overflow_out = 1'b0;
            flag_out = 1'b0;
        end
    endcase
end

// Assign outputs
always @(*) begin
    r = res;
    carry = carry_out;
    overflow = overflow_out;
    flag = flag_out;
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule