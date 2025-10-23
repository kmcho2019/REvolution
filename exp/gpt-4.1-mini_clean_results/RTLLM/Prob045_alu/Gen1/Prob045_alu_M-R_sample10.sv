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

// Define opcodes as parameters
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

// Decode opcode to one-hot signals for clarity
wire is_add  = (aluc == ADD);
wire is_addu = (aluc == ADDU);
wire is_sub  = (aluc == SUB);
wire is_subu = (aluc == SUBU);
wire is_and  = (aluc == AND);
wire is_or   = (aluc == OR);
wire is_xor  = (aluc == XOR);
wire is_nor  = (aluc == NOR);
wire is_slt  = (aluc == SLT);
wire is_sltu = (aluc == SLTU);
wire is_sll  = (aluc == SLL);
wire is_srl  = (aluc == SRL);
wire is_sra  = (aluc == SRA);
wire is_sllv = (aluc == SLLV);
wire is_srlv = (aluc == SRLV);
wire is_srav = (aluc == SRAV);
wire is_lui  = (aluc == LUI);

// Signed and unsigned versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts from a[4:0]
wire [4:0] shamt = a[4:0];

// Intermediate operation results
wire [32:0] add_res = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);

wire [31:0] slt_res = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

wire [31:0] sll_res = b << shamt;
wire [31:0] srl_res = b >> shamt;
wire [31:0] sra_res = $signed(b_s) >>> shamt;

wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

wire [31:0] lui_res = {a[15:0], 16'b0};

// Select result based on opcode
wire [31:0] result =
    is_add  ? add_res[31:0] :
    is_addu ? addu_res[31:0] :
    is_sub  ? sub_res[31:0] :
    is_subu ? subu_res[31:0] :
    is_and  ? and_res :
    is_or   ? or_res :
    is_xor  ? xor_res :
    is_nor  ? nor_res :
    is_slt  ? slt_res :
    is_sltu ? sltu_res :
    is_sll  ? sll_res :
    is_srl  ? srl_res :
    is_sra  ? sra_res :
    is_sllv ? sllv_res :
    is_srlv ? srlv_res :
    is_srav ? srav_res :
    is_lui  ? lui_res :
              32'b0; // default zero if unknown opcode

assign r = result;

// zero flag is high if r == 0
assign zero = (result == 32'b0);

// carry flag for add/sub (borrow inverted) only valid on add/sub operations, else zero
assign carry =
    is_add  ? add_res[32] :
    is_addu ? addu_res[32] :
    is_sub  ? (a >= b) :  // borrow inverted is carry
    is_subu ? (a >= b) :
    1'b0;

// overflow flag only meaningful for signed add and sub
assign overflow =
    is_add  ? ((a[31] == b[31]) && (result[31] != a[31])) :
    is_sub  ? ((a[31] != b[31]) && (result[31] != a[31])) :
    1'b0;

// negative flag is the sign bit of result
assign negative = result[31];

// flag is set only for SLT/SLTU operations, else high impedance 'z'
// High impedance can't be assigned in wire, so we assign 0 when not SLT/SLTU as safe alternative
assign flag = (is_slt || is_sltu) ? 
              (is_slt ? slt_flag : sltu_flag) : 
              1'b0;

endmodule