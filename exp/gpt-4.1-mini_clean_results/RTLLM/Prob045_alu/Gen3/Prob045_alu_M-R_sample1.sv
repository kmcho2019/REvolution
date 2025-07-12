module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output       flag
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

// Signed versions of inputs for arithmetic/logic
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Extended operands for carry/overflow detection
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] addu_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};
wire [32:0] subu_ext = {1'b0, a} - {1'b0, b};

wire signed [32:0] add_s_ext = {a_s[31], a_s} + {b_s[31], b_s};
wire signed [32:0] sub_s_ext = {a_s[31], a_s} - {b_s[31], b_s};

// Arithmetic results
wire [31:0] add_res  = add_ext[31:0];
wire [31:0] addu_res = addu_ext[31:0];
wire [31:0] sub_res  = sub_ext[31:0];
wire [31:0] subu_res = subu_ext[31:0];

// Carry flags for add/sub (unsigned)
wire add_carry  = add_ext[32];
wire addu_carry = addu_ext[32];
// For subtraction, carry = no borrow: c=1 if a >= b (unsigned)
wire sub_carry  = (a >= b) ? 1'b1 : 1'b0;
wire subu_carry = (a >= b) ? 1'b1 : 1'b0;

// Overflow detection for signed add/sub
// Add overflow: if sign of a == sign of b and result sign != a sign
wire add_ovf = (~(a_s[31] ^ b_s[31])) & (a_s[31] ^ add_res[31]);
// Sub overflow: if sign of a != sign of b and result sign != a sign
wire sub_ovf = (a_s[31] ^ b_s[31]) & (a_s[31] ^ sub_res[31]);

// Logic operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// SLT and SLTU flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res  = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

// Shift amounts for shifts: lower 5 bits of a (variable shifts)
wire [4:0] shamt = a[4:0];

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;

// Shifts with variable shift amount in a (SLLV, SRLV, SRAV use a as shift amount)
wire [31:0] sllv_res = b << shamt;
wire [31:0] srlv_res = b >> shamt;
wire [31:0] srav_res = $signed(b) >>> shamt;

// LUI operation: load upper immediate; upper 16 bits = b[15:0], lower 16 bits zeros
wire [31:0] lui_res = {b[15:0], 16'b0};

// Result mux based on opcode
wire [31:0] res = (aluc == ADD)  ? add_res  :
                  (aluc == ADDU) ? addu_res :
                  (aluc == SUB)  ? sub_res  :
                  (aluc == SUBU) ? subu_res :
                  (aluc == AND)  ? and_res  :
                  (aluc == OR)   ? or_res   :
                  (aluc == XOR)  ? xor_res  :
                  (aluc == NOR)  ? nor_res  :
                  (aluc == SLT)  ? slt_res  :
                  (aluc == SLTU) ? sltu_res :
                  (aluc == SLL)  ? sll_res  :
                  (aluc == SRL)  ? srl_res  :
                  (aluc == SRA)  ? sra_res  :
                  (aluc == SLLV) ? sllv_res :
                  (aluc == SRLV) ? srlv_res :
                  (aluc == SRAV) ? srav_res :
                  (aluc == LUI)  ? lui_res  :
                                   32'b0;

// Carry mux (meaningful only for add/sub)
wire carry_val = (aluc == ADD)  ? add_carry  :
                 (aluc == ADDU) ? addu_carry :
                 (aluc == SUB)  ? sub_carry  :
                 (aluc == SUBU) ? subu_carry :
                                  1'b0;

// Overflow mux (meaningful only for signed add/sub)
wire overflow_val = (aluc == ADD) ? add_ovf :
                    (aluc == SUB) ? sub_ovf :
                                   1'b0;

// Flag mux: set only for SLT and SLTU; else high impedance 'z' (tri-state style)
wire flag_val = (aluc == SLT)  ? slt_flag  :
                (aluc == SLTU) ? sltu_flag :
                                1'bz;

// Zero and negative flags
wire zero_val = (res == 32'b0);
wire negative_val = res[31];

// Output assignments
assign r = res;
assign carry = carry_val;
assign overflow = overflow_val;
assign zero = zero_val;
assign negative = negative_val;
assign flag = flag_val;

endmodule