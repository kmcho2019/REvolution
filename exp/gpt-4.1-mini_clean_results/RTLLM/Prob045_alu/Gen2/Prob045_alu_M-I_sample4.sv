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

// Shift amounts extracted from 'a' as per spec
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Single signed adder/subtractor for ADD and SUB operations
reg signed [32:0] signed_alu_res;
reg carry_out_alu;
reg overflow_alu;

// Combinational process to calculate signed add/sub, carry and overflow
always @(*) begin
    carry_out_alu = 1'b0;
    overflow_alu = 1'b0;
    signed_alu_res = 33'd0;
    case (aluc)
        ADD: begin
            signed_alu_res = {a_signed[31], a_signed} + {b_signed[31], b_signed};
            carry_out_alu = signed_alu_res[32];
            // Overflow detection for addition:
            // If sign of operands same, but sign of result differs, overflow
            overflow_alu = ((a_signed[31] == b_signed[31]) && (signed_alu_res[31] != a_signed[31])) ? 1'b1 : 1'b0;
        end
        SUB: begin
            signed_alu_res = {a_signed[31], a_signed} - {b_signed[31], b_signed};
            // For carry in subtraction: carry=1 if no borrow (a unsigned >= b unsigned)
            carry_out_alu = (a >= b) ? 1'b1 : 1'b0;
            // Overflow detection for subtraction:
            // If signs differ, and result sign differs from a's sign, overflow
            overflow_alu = ((a_signed[31] != b_signed[31]) && (signed_alu_res[31] != a_signed[31])) ? 1'b1 : 1'b0;
        end
        default: begin
            signed_alu_res = 33'd0;
            carry_out_alu = 1'b0;
            overflow_alu = 1'b0;
        end
    endcase
end

// Unsigned add/sub results for ADDU and SUBU
reg [32:0] unsigned_alu_res;
reg carry_out_unsigned;

always @(*) begin
    carry_out_unsigned = 1'b0;
    unsigned_alu_res = 33'd0;
    case (aluc)
        ADDU: begin
            unsigned_alu_res = {1'b0, a} + {1'b0, b};
            carry_out_unsigned = unsigned_alu_res[32];
        end
        SUBU: begin
            unsigned_alu_res = {1'b0, a} - {1'b0, b};
            // carry meaning no borrow
            carry_out_unsigned = (a >= b) ? 1'b1 : 1'b0;
        end
        default: begin
            unsigned_alu_res = 33'd0;
            carry_out_unsigned = 1'b0;
        end
    endcase
end

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res  = b << shamt_imm;
wire [31:0] srl_res  = b >> shamt_imm;
wire [31:0] sra_res  = $signed(b) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b) >>> shamt_var;

// LUI operation
wire [31:0] lui_res = {b[15:0],16'b0};

// SLT/SLTU flags
wire slt_flag = (a_signed < b_signed);
wire sltu_flag = (a < b);

// Combinational output selection based on aluc
always @(*) begin
    r = 32'd0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            r = signed_alu_res[31:0];
            carry = carry_out_alu;
            overflow = overflow_alu;
            flag = 1'b0;
        end
        ADDU: begin
            r = unsigned_alu_res[31:0];
            carry = carry_out_unsigned;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            r = signed_alu_res[31:0];
            carry = carry_out_alu;
            overflow = overflow_alu;
            flag = 1'b0;
        end
        SUBU: begin
            r = unsigned_alu_res[31:0];
            carry = carry_out_unsigned;
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = and_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = or_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = xor_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = nor_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = 32'd0;
            r[0] = slt_flag;
            flag = slt_flag;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            r = 32'd0;
            r[0] = sltu_flag;
            flag = sltu_flag;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            r = sll_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = srl_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = sra_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = sllv_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = srlv_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = srav_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = lui_res;
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
end

assign zero = (r == 32'd0);
assign negative = r[31];

endmodule