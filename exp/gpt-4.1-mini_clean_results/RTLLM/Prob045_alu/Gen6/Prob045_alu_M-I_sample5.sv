module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output flag
);

// Opcode parameters
localparam ADD   = 6'b100000;
localparam ADDU  = 6'b100001;
localparam SUB   = 6'b100010;
localparam SUBU  = 6'b100011;
localparam AND   = 6'b100100;
localparam OR    = 6'b100101;
localparam XOR   = 6'b100110;
localparam NOR   = 6'b100111;
localparam SLT   = 6'b101010;
localparam SLTU  = 6'b101011;
localparam SLL   = 6'b000000;
localparam SRL   = 6'b000010;
localparam SRA   = 6'b000011;
localparam SLLV  = 6'b000100;
localparam SRLV  = 6'b000110;
localparam SRAV  = 6'b000111;
localparam LUI   = 6'b001111;

// Signed versions for signed ops
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Shift amounts
wire [4:0] shamt_imm = a[4:0];  // shift amount from a for SLL, SRL, SRA
wire [4:0] shamt_var = a[4:0];  // shift amount for variable shifts

// Opcode group decoding to gate operations (simplifies mux and logic)
wire is_add_arith  = (aluc == ADD) || (aluc == ADDU);
wire is_sub_arith  = (aluc == SUB) || (aluc == SUBU);
wire is_arith      = is_add_arith || is_sub_arith;
wire is_logic      = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
wire is_slt        = (aluc == SLT);
wire is_sltu       = (aluc == SLTU);
wire is_shift_imm  = (aluc == SLL) || (aluc == SRL) || (aluc == SRA);
wire is_shift_var  = (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
wire is_lui        = (aluc == LUI);

// Arithmetic computation with overflow and carry detection for signed add/sub
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};

// Signed add/sub for overflow
wire signed [32:0] add_s_ext = {a_s[31], a_s} + {b_s[31], b_s};
wire signed [32:0] sub_s_ext = {a_s[31], a_s} - {b_s[31], b_s};

wire [31:0] res_addu = add_ext[31:0];
wire        carry_addu = add_ext[32];

wire [31:0] res_addu = res_addu; // alias for clarity

wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = sub_ext[32]; // carry out from subtraction (unsigned borrow), typically not used as carry

wire [31:0] res_add = add_s_ext[31:0];
wire        carry_add = add_s_ext[32];

wire [31:0] res_sub = sub_s_ext[31:0];
wire        carry_sub = sub_s_ext[32];

// Overflow detection functions
function overflow_add_func;
    input [31:0] a_f, b_f, r_f;
    begin
        // Overflow if sign of a and b same and sign of result different
        overflow_add_func = (~a_f[31] & ~b_f[31] & r_f[31]) | (a_f[31] & b_f[31] & ~r_f[31]);
    end
endfunction

function overflow_sub_func;
    input [31:0] a_f, b_f, r_f;
    begin
        // Overflow if a positive b negative and result negative, or a negative b positive and result positive
        overflow_sub_func = (a_f[31] & ~b_f[31] & ~r_f[31]) | (~a_f[31] & b_f[31] & r_f[31]);
    end
endfunction

wire overflow_add = overflow_add_func(a, b, res_add);
wire overflow_sub = overflow_sub_func(a, b, res_sub);

// Bitwise operations
wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

// SLT and SLTU
wire slt_flag = (a_s < b_s);
wire [31:0] res_slt = slt_flag ? 32'd1 : 32'd0;

wire sltu_flag = (a < b);
wire [31:0] res_sltu = sltu_flag ? 32'd1 : 32'd0;

// Shift immediate operations use shamt_imm
wire [31:0] res_sll  = b << shamt_imm;
wire [31:0] res_srl  = b >> shamt_imm;
wire [31:0] res_sra  = $signed(b) >>> shamt_imm;

// Shift variable operations use shamt_var
wire [31:0] res_sllv = b << shamt_var;
wire [31:0] res_srlv = b >> shamt_var;
wire [31:0] res_srav = $signed(b) >>> shamt_var;

// LUI - upper 16 bits of 'a' concatenated with 16'b0 (corrected from original)
wire [31:0] res_lui = {a[31:16], 16'b0};

// Default zero result for undefined opcode
wire [31:0] res_default = 32'b0;

// Combining arithmetic results (select add or sub with signed/unsigned variants)
wire [31:0] res_arith = (aluc == ADD)  ? res_add  :
                        (aluc == ADDU) ? res_addu :
                        (aluc == SUB)  ? res_sub  :
                        (aluc == SUBU) ? res_subu :
                        32'b0;

// Carry and overflow signals only valid for signed add/sub (ADD, SUB)
wire carry_arith = (aluc == ADD) ? carry_add : 1'b0;
wire overflow_arith = (aluc == ADD) ? overflow_add :
                      (aluc == SUB) ? overflow_sub : 1'b0;

// Logic results mux
wire [31:0] res_logic = (aluc == AND) ? res_and :
                       (aluc == OR)  ? res_or  :
                       (aluc == XOR) ? res_xor :
                       (aluc == NOR) ? res_nor :
                       32'b0;

// Shift immediate mux
wire [31:0] res_shift_imm = (aluc == SLL) ? res_sll :
                           (aluc == SRL) ? res_srl :
                           (aluc == SRA) ? res_sra :
                           32'b0;

// Shift variable mux
wire [31:0] res_shift_var = (aluc == SLLV) ? res_sllv :
                           (aluc == SRLV) ? res_srlv :
                           (aluc == SRAV) ? res_srav :
                           32'b0;

// Final combinational result mux with gated operation blocks to reduce logic complexity
always @(*) begin
    case (1'b1) // one-hot style selection
        is_arith:   r = res_arith;
        is_logic:   r = res_logic;
        is_slt:     r = res_slt;
        is_sltu:    r = res_sltu;
        is_shift_imm: r = res_shift_imm;
        is_shift_var: r = res_shift_var;
        is_lui:     r = res_lui;
        default:    r = res_default;
    endcase
end

// Zero and negative flag
assign zero = (r == 32'b0);
assign negative = r[31];

// Carry and overflow: meaningful only for ADD and SUB signed ops, else zero
assign carry = (aluc == ADD) ? carry_arith : 1'b0;
assign overflow = overflow_arith;

// Flag output: high impedance when not SLT or SLTU, else 1 or 0 accordingly
assign flag = (aluc == SLT)  ? slt_flag  :
              (aluc == SLTU) ? sltu_flag :
              1'bz;

endmodule