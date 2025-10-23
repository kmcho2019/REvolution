module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
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

// Shift amount from lower 5 bits of a
wire [4:0] shamt = a[4:0];

// Signed versions for signed operations
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Extended arithmetic for carry and overflow detection (33-bit)
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};

// Arithmetic results
wire [31:0] add_r    = add_res[31:0];
wire        add_carry= add_res[32];

wire [31:0] sub_r    = sub_res[31:0];
wire        sub_carry= sub_res[32];

// Arithmetic overflow detection
// ADD overflow: if a and b have same sign but result has different sign
wire add_overflow = (~a[31] & ~b[31] & add_r[31]) | (a[31] & b[31] & ~add_r[31]);
// SUB overflow: if a and b have different signs and result sign differs from a
wire sub_overflow = (a[31] & ~b[31] & ~sub_r[31]) | (~a[31] & b[31] & sub_r[31]);

// Logical operations
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// Set less than (signed)
wire slt_flag = (a_s < b_s);
wire [31:0] slt_r = {31'b0, slt_flag};

// Set less than unsigned
wire sltu_flag = (a < b);
wire [31:0] sltu_r = {31'b0, sltu_flag};

// Shift operations
wire [31:0] sll_r  = b << shamt;
wire [31:0] srl_r  = b >> shamt;
wire [31:0] sra_r  = b_s >>> shamt;

wire [31:0] sllv_r = b << shamt;
wire [31:0] srlv_r = b >> shamt;
wire [31:0] srav_r = b_s >>> shamt;

// Load upper immediate
wire [31:0] lui_r = a << 16;

// Default result zero for invalid opcodes
wire [31:0] zero_r = 32'b0;

// Main result mux
wire [31:0] result =
    (aluc == ADD)  ? add_r  :
    (aluc == ADDU) ? add_r  :
    (aluc == SUB)  ? sub_r  :
    (aluc == SUBU) ? sub_r  :
    (aluc == AND)  ? and_r  :
    (aluc == OR)   ? or_r   :
    (aluc == XOR)  ? xor_r  :
    (aluc == NOR)  ? nor_r  :
    (aluc == SLT)  ? slt_r  :
    (aluc == SLTU) ? sltu_r :
    (aluc == SLL)  ? sll_r  :
    (aluc == SRL)  ? srl_r  :
    (aluc == SRA)  ? sra_r  :
    (aluc == SLLV) ? sllv_r :
    (aluc == SRLV) ? srlv_r :
    (aluc == SRAV) ? srav_r :
    (aluc == LUI)  ? lui_r  :
                     zero_r;

// Carry output only for ADD, ADDU, SUB, SUBU
wire carry_out =
    (aluc == ADD)  ? add_carry  :
    (aluc == ADDU) ? add_carry  :
    (aluc == SUB)  ? sub_carry  :
    (aluc == SUBU) ? sub_carry  :
                    1'b0;

// Overflow output only for ADD and SUB signed
wire overflow_out =
    (aluc == ADD) ? add_overflow :
    (aluc == SUB) ? sub_overflow :
                   1'b0;

// Negative flag from result sign bit
wire negative_out = result[31];

// Zero flag when result is zero
wire zero_out = (result == 32'b0);

// Flag output only meaningful for SLT and SLTU
wire flag_out =
    (aluc == SLT)  ? slt_flag  :
    (aluc == SLTU) ? sltu_flag :
                    1'b0;

// Assign outputs
assign r        = result;
assign carry    = carry_out;
assign overflow = overflow_out;
assign negative = negative_out;
assign zero     = zero_out;
assign flag     = flag_out;

endmodule