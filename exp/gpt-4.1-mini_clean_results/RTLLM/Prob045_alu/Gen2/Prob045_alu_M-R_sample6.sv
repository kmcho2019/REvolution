module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
);

// Opcode parameters
parameter ADD   = 6'b100000;
parameter ADDU  = 6'b100001;
parameter SUB   = 6'b100010;
parameter SUBU  = 6'b100011;
parameter AND   = 6'b100100;
parameter OR    = 6'b100101;
parameter XOR   = 6'b100110;
parameter NOR   = 6'b100111;
parameter SLT   = 6'b101010;
parameter SLTU  = 6'b101011;
parameter SLL   = 6'b000000;
parameter SRL   = 6'b000010;
parameter SRA   = 6'b000011;
parameter SLLV  = 6'b000100;
parameter SRLV  = 6'b000110;
parameter SRAV  = 6'b000111;
parameter LUI   = 6'b001111;

// Signed versions for signed operations
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Shift amount from a[4:0]
wire [4:0] shamt = a[4:0];

// Extended addition and subtraction for carry/overflow detection
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] add_s_ext = {a[31], a} + {b[31], b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};
wire [32:0] sub_s_ext = {a[31], a} - {b[31], b};

// Results of arithmetic operations
wire [31:0] res_addu = add_ext[31:0];
wire        carry_addu = add_ext[32];
wire [31:0] res_add  = add_s_ext[31:0];
wire        carry_add = add_s_ext[32];
wire        overflow_add = (~a[31] & ~b[31] & res_add[31]) | (a[31] & b[31] & ~res_add[31]);

wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = sub_ext[32];
wire [31:0] res_sub  = sub_s_ext[31:0];
wire        carry_sub = sub_s_ext[32];
wire        overflow_sub = (a[31] & ~b[31] & ~res_sub[31]) | (~a[31] & b[31] & res_sub[31]);

// Bitwise operations
wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

// SLT and SLTU computations
wire slt_flag = (a_s < b_s);
wire [31:0] res_slt  = slt_flag ? 32'd1 : 32'd0;

wire sltu_flag = (a < b);
wire [31:0] res_sltu = sltu_flag ? 32'd1 : 32'd0;

// Shift operations using shamt
wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = $signed(b) >>> shamt;

// Variable shift operations using shamt
wire [31:0] res_sllv = b << shamt;
wire [31:0] res_srlv = b >> shamt;
wire [31:0] res_srav = $signed(b) >>> shamt;

// LUI operation: upper 16 bits of 'a' concatenated with 16 zeros (as per problem description)
wire [31:0] res_lui  = {a[15:0], 16'b0};

// Default result (all zeros) for undefined opcodes
wire [31:0] res_default = 32'b0;

// Combinational mux for output result
assign r = (aluc == ADD)  ? res_add  :
           (aluc == ADDU) ? res_addu :
           (aluc == SUB)  ? res_sub  :
           (aluc == SUBU) ? res_subu :
           (aluc == AND)  ? res_and  :
           (aluc == OR)   ? res_or   :
           (aluc == XOR)  ? res_xor  :
           (aluc == NOR)  ? res_nor  :
           (aluc == SLT)  ? res_slt  :
           (aluc == SLTU) ? res_sltu :
           (aluc == SLL)  ? res_sll  :
           (aluc == SRL)  ? res_srl  :
           (aluc == SRA)  ? res_sra  :
           (aluc == SLLV) ? res_sllv :
           (aluc == SRLV) ? res_srlv :
           (aluc == SRAV) ? res_srav :
           (aluc == LUI)  ? res_lui  :
           res_default;

// Zero flag: 1 if r is zero, else 0
assign zero = (r == 32'b0);

// Negative flag: most significant bit of r
assign negative = r[31];

// Carry flag only valid for add/sub operations, else 0
assign carry = (aluc == ADD)  ? carry_add  :
               (aluc == ADDU) ? carry_addu :
               (aluc == SUB)  ? carry_sub  :
               (aluc == SUBU) ? carry_subu :
               1'b0;

// Overflow flag valid only for signed add/sub
assign overflow = (aluc == ADD) ? overflow_add :
                  (aluc == SUB) ? overflow_sub :
                  1'b0;

// Flag output set to 1 or 0 for SLT/SLTU, 0 otherwise (no 'z' to avoid simulation issues)
assign flag = (aluc == SLT)  ? slt_flag  :
              (aluc == SLTU) ? sltu_flag :
              1'b0;

endmodule