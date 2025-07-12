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

// ------ Arithmetic group ------
// Extended add/sub for carry/overflow detection
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] add_s_ext = {a[31], a} + {b[31], b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};
wire [32:0] sub_s_ext = {a[31], a} - {b[31], b};

// Unsigned arithmetic results
wire [31:0] res_addu = add_ext[31:0];
wire        carry_addu = add_ext[32];
wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = ~sub_ext[32]; 
// For subtraction borrow detection in unsigned, carry flag usually means no borrow if 1.
// MIPS convention for carry on SUBU: borrow indicated by carry=0, so invert

// Signed arithmetic results
wire [31:0] res_add  = add_s_ext[31:0];
wire        overflow_add = (~a[31] & ~b[31] & res_add[31]) | (a[31] & b[31] & ~res_add[31]);

wire [31:0] res_sub  = sub_s_ext[31:0];
wire        overflow_sub = (a[31] & ~b[31] & ~res_sub[31]) | (~a[31] & b[31] & res_sub[31]);

// ------ Logic group ------
wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

// ------ Set less than ------
wire slt_flag  = (a_s < b_s);
wire [31:0] res_slt  = slt_flag ? 32'd1 : 32'd0;

wire sltu_flag = (a < b);
wire [31:0] res_sltu = sltu_flag ? 32'd1 : 32'd0;

// ------ Shift operations with shamt from a[4:0] ------
wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = $signed(b) >>> shamt;

wire [31:0] res_sllv = b << shamt;
wire [31:0] res_srlv = b >> shamt;
wire [31:0] res_srav = $signed(b) >>> shamt;

// ------ LUI operation ------
// According to MIPS, load immediate shifted left 16 bits:
// "Load upper immediate" loads 16-bit immediate into upper half, zeros lower half
// Problem statement: upper 16 bits of 'a' concatenated with 16 zeros
wire [31:0] res_lui = {a[31:16], 16'b0};

// ------- Group decoding -------
wire is_arith_add  = (aluc == ADD);
wire is_arith_addu = (aluc == ADDU);
wire is_arith_sub  = (aluc == SUB);
wire is_arith_subu = (aluc == SUBU);

wire is_logic_and = (aluc == AND);
wire is_logic_or  = (aluc == OR);
wire is_logic_xor = (aluc == XOR);
wire is_logic_nor = (aluc == NOR);

wire is_slt   = (aluc == SLT);
wire is_sltu  = (aluc == SLTU);

wire is_shift_sll  = (aluc == SLL);
wire is_shift_srl  = (aluc == SRL);
wire is_shift_sra  = (aluc == SRA);
wire is_shift_sllv = (aluc == SLLV);
wire is_shift_srlv = (aluc == SRLV);
wire is_shift_srav = (aluc == SRAV);

wire is_lui = (aluc == LUI);

// ------- Select output from groups -------
// Arithmetic group mux
wire [31:0] arith_res =
    is_arith_add  ? res_add  :
    is_arith_addu ? res_addu :
    is_arith_sub  ? res_sub  :
    is_arith_subu ? res_subu :
    32'b0;

// Logic group mux
wire [31:0] logic_res =
    is_logic_and ? res_and :
    is_logic_or  ? res_or  :
    is_logic_xor ? res_xor :
    is_logic_nor ? res_nor :
    32'b0;

// Shift group mux
wire [31:0] shift_res =
    is_shift_sll  ? res_sll  :
    is_shift_srl  ? res_srl  :
    is_shift_sra  ? res_sra  :
    is_shift_sllv ? res_sllv :
    is_shift_srlv ? res_srlv :
    is_shift_srav ? res_srav :
    32'b0;

// SLT group mux
wire [31:0] slt_res =
    is_slt  ? res_slt  :
    is_sltu ? res_sltu :
    32'b0;

// Combine all groups and LUI
wire [31:0] r_internal =
    is_arith_add  ? arith_res :
    is_arith_addu ? arith_res :
    is_arith_sub  ? arith_res :
    is_arith_subu ? arith_res :
    is_logic_and  ? logic_res :
    is_logic_or   ? logic_res :
    is_logic_xor  ? logic_res :
    is_logic_nor  ? logic_res :
    is_slt        ? slt_res :
    is_sltu       ? slt_res :
    is_shift_sll  ? shift_res :
    is_shift_srl  ? shift_res :
    is_shift_sra  ? shift_res :
    is_shift_sllv ? shift_res :
    is_shift_srlv ? shift_res :
    is_shift_srav ? shift_res :
    is_lui        ? res_lui :
    32'b0;

// Assign output result
assign r = r_internal;

// zero flag: 1 if result is zero
assign zero = (r == 32'b0);

// negative flag: sign bit of result
assign negative = r[31];

// carry flag for add/sub only, 0 else
// For SUBU and ADDU, MIPS carry bit is interpreted as borrow for SUBU
wire carry_add_sub =
    is_arith_add  ? add_ext[32]    : // carry out of unsigned addition
    is_arith_addu ? add_ext[32]    : 
    is_arith_sub  ? ~sub_ext[32]   : // borrow flag for unsigned subtraction, invert bit 32
    is_arith_subu ? ~sub_ext[32]   :
    1'b0;

assign carry = carry_add_sub;

// overflow for signed add/sub only, else 0
wire overflow_add_sub =
    is_arith_add ? overflow_add :
    is_arith_sub ? overflow_sub :
    1'b0;

assign overflow = overflow_add_sub;

// flag output for SLT and SLTU only, 0 else
assign flag =
    is_slt  ? slt_flag  :
    is_sltu ? sltu_flag :
    1'b0;

endmodule