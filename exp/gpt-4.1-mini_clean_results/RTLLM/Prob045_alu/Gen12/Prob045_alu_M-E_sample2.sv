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

wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Arithmetic additions and subtractions with carry bit (33-bit wires)
wire [32:0] add_full   = {1'b0, a} + {1'b0, b};
wire [32:0] addu_full  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_full   = {1'b0, a} - {1'b0, b};
wire [32:0] subu_full  = {1'b0, a} - {1'b0, b};

// Logical operations
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// Shift amounts
wire [4:0] shamt_fixed = b[4:0]; // For fixed shift instructions
wire [4:0] shamt_var   = a[4:0]; // For variable shift instructions

// Shift operations
wire [31:0] sll_r  = b << shamt_fixed;
wire [31:0] srl_r  = b >> shamt_fixed;
wire [31:0] sra_r  = $signed(b) >>> shamt_fixed;
wire [31:0] sllv_r = b << shamt_var;
wire [31:0] srlv_r = b >> shamt_var;
wire [31:0] srav_r = $signed(b) >>> shamt_var;

// LUI operation: Load upper immediate, as per spec it is {a[15:0],16'b0}
wire [31:0] lui_r = {a[15:0], 16'b0};

// SLT and SLTU flags
wire slt_flag  = (a_s < b_s) ? 1'b1 : 1'b0;
wire sltu_flag = (a < b) ? 1'b1 : 1'b0;

reg [31:0] result;
reg carry_flag;
reg overflow_flag;
reg flag_reg;

always @(*) begin
    // Defaults
    result = 32'b0;
    carry_flag = 1'b0;
    overflow_flag = 1'b0;
    flag_reg = 1'b0;

    case(aluc)
        ADD: begin
            result = add_full[31:0];
            carry_flag = add_full[32];
            // Overflow detection: if a and b have same sign, but result sign differs
            overflow_flag = (~a[31] & ~b[31] & result[31]) | (a[31] & b[31] & ~result[31]);
        end
        ADDU: begin
            result = addu_full[31:0];
            carry_flag = addu_full[32];
            overflow_flag = 1'b0; // No overflow for unsigned add
        end
        SUB: begin
            result = sub_full[31:0];
            carry_flag = sub_full[32];
            // Overflow detection: if a and b have different signs and result sign differs from a
            overflow_flag = (a[31] & ~b[31] & ~result[31]) | (~a[31] & b[31] & result[31]);
        end
        SUBU: begin
            result = subu_full[31:0];
            carry_flag = subu_full[32];
            overflow_flag = 1'b0; // No overflow for unsigned sub
        end
        AND:  result = and_r;
        OR:   result = or_r;
        XOR:  result = xor_r;
        NOR:  result = nor_r;
        SLT:  begin
            flag_reg = slt_flag;
            result = {31'b0, flag_reg};
        end
        SLTU: begin
            flag_reg = sltu_flag;
            result = {31'b0, flag_reg};
        end
        SLL:  result = sll_r;
        SRL:  result = srl_r;
        SRA:  result = sra_r;
        SLLV: result = sllv_r;
        SRLV: result = srlv_r;
        SRAV: result = srav_r;
        LUI:  result = lui_r;
        default: begin
            result = 32'b0;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
            flag_reg = 1'b0;
        end
    endcase

    r = result;
    carry = carry_flag;
    overflow = overflow_flag;
    flag = (aluc == SLT || aluc == SLTU) ? flag_reg : 1'bz;
    zero = (result == 32'b0);
    negative = result[31];
end

endmodule