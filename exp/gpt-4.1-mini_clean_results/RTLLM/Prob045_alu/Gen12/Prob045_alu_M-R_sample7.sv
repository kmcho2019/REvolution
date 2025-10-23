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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];
wire [4:0] shamt_v = a[4:0];

// Functions to calculate carry and overflow for addition and subtraction
function [32:0] add_carry;
    input [31:0] x;
    input [31:0] y;
    begin
        add_carry = {1'b0, x} + {1'b0, y};
    end
endfunction

function [32:0] sub_carry;
    input [31:0] x;
    input [31:0] y;
    begin
        sub_carry = {1'b0, x} - {1'b0, y};
    end
endfunction

// ADD operation
wire [32:0] add_res = add_carry(a, b);
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);

// ADDU operation (no overflow)
wire [32:0] addu_res = add_carry(a, b);

// SUB operation
wire [32:0] sub_res = sub_carry(a, b);
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// SUBU operation
wire [32:0] subu_res = sub_carry(a, b);

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// SLT and SLTU flags and results
wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << shamt_v;
wire [31:0] srlv_res = b >> shamt_v;
wire [31:0] srav_res = $signed(b_s) >>> shamt_v;

// LUI operation: upper 16 bits of a concatenated with 16 zeros (MIPS LUI loads immediate into upper half)
// The problem states "For the LUI operation, the upper 16 bits of 'a' are concatenated with 16 zeros"
// But LUI typically uses immediate shifted by 16 bits (imm<<16) ignoring 'a'.
// Here we interpret 'a' as immediate input to upper bits for LUI as per problem statement.
wire [31:0] lui_res = {a[15:0], 16'b0};

// Default zero result for unknown opcodes
wire [31:0] default_res = 32'b0;

// Result mux
wire [31:0] r_mux = 
    (aluc == ADD)  ? add_res[31:0] :
    (aluc == ADDU) ? addu_res[31:0] :
    (aluc == SUB)  ? sub_res[31:0] :
    (aluc == SUBU) ? subu_res[31:0] :
    (aluc == AND)  ? and_res :
    (aluc == OR)   ? or_res :
    (aluc == XOR)  ? xor_res :
    (aluc == NOR)  ? nor_res :
    (aluc == SLT)  ? slt_res :
    (aluc == SLTU) ? sltu_res :
    (aluc == SLL)  ? sll_res :
    (aluc == SRL)  ? srl_res :
    (aluc == SRA)  ? sra_res :
    (aluc == SLLV) ? sllv_res :
    (aluc == SRLV) ? srlv_res :
    (aluc == SRAV) ? srav_res :
    (aluc == LUI)  ? lui_res :
    default_res;

// Carry mux
wire carry_mux =
    (aluc == ADD)  ? add_res[32] :
    (aluc == ADDU) ? addu_res[32] :
    (aluc == SUB)  ? sub_res[32] :
    (aluc == SUBU) ? subu_res[32] :
    1'b0;

// Overflow mux
wire overflow_mux =
    (aluc == ADD) ? add_overflow :
    (aluc == SUB) ? sub_overflow :
    1'b0;

// Flag mux (only for SLT and SLTU)
wire flag_mux =
    (aluc == SLT)  ? slt_flag :
    (aluc == SLTU) ? sltu_flag :
    1'b0;

// Output assignments
assign r = r_mux;
assign carry = carry_mux;
assign overflow = overflow_mux;
assign flag = flag_mux;
assign zero = (r == 32'b0);
assign negative = r[31];

endmodule