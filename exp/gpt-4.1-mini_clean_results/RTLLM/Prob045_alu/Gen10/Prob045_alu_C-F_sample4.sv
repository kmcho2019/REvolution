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

// Opcode parameters for MIPS ISA ALU operations
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

// Signed versions of inputs for arithmetic and comparison
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Determine whether current operation is subtraction
wire is_subtract = (aluc == SUB) || (aluc == SUBU);

// Shared adder-subtractor, extended to 33 bits to capture carry/borrow
wire [32:0] add_sub_res = is_subtract ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
wire [31:0] add_sub_result = add_sub_res[31:0];
wire carry_out = add_sub_res[32];

// Overflow detection for signed addition and subtraction
wire add_overflow = (~a[31] & ~b[31] & add_sub_result[31]) | (a[31] & b[31] & ~add_sub_result[31]);
wire sub_overflow = (a[31] & ~b[31] & ~add_sub_result[31]) | (~a[31] & b[31] & add_sub_result[31]);

// Carry flag interpretation:
// For addition instructions, carry_out is carry flag.
// For subtraction instructions, carry flag means borrow did NOT occur (i.e., a >= b).
wire carry_flag = is_subtract ? (a >= b) : carry_out;

// Shift amounts derived from lower 5 bits of 'a' or 'b' depending on instruction
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Set less than computations
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift operations on b using immediate or variable shift amount
wire [31:0] sll_res  = b << shamt_imm;
wire [31:0] srl_res  = b >> shamt_imm;
wire [31:0] sra_res  = $signed(b_s) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b_s) >>> shamt_var;

// LUI operation: Shift lower 16 bits of 'a' to upper 16 bits of result, lower 16 bits zero
wire [31:0] lui_res = {a[15:0], 16'b0};

// Default outputs if no operation matched
wire [31:0] default_res = 32'b0;

always @(*) begin
    // Default output values
    r = default_res;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;
    zero = 1'b0;

    case (aluc)
        ADD: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = add_overflow;
        end
        ADDU: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = 1'b0; // no overflow for unsigned addition
        end
        SUB: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = sub_overflow;
        end
        SUBU: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = 1'b0; // no overflow for unsigned subtraction
        end
        AND: begin
            r = and_res;
        end
        OR: begin
            r = or_res;
        end
        XOR: begin
            r = xor_res;
        end
        NOR: begin
            r = nor_res;
        end
        SLT: begin
            flag = slt_flag ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = sltu_flag ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL: begin
            r = sll_res;
        end
        SRL: begin
            r = srl_res;
        end
        SRA: begin
            r = sra_res;
        end
        SLLV: begin
            r = sllv_res;
        end
        SRLV: begin
            r = srlv_res;
        end
        SRAV: begin
            r = srav_res;
        end
        LUI: begin
            r = lui_res;
        end
        default: begin
            r = default_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    // Zero and Negative flags always from result
    zero = (r == 32'b0);
    negative = r[31];
end

endmodule