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

// Opcodes as parameters
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

wire [4:0] shamt = a[4:0];

// Arithmetic operations with 33-bit for carry detection
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Set less than operations
wire slt_res  = ($signed(a) < $signed(b));
wire sltu_res = (a < b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];

// LUI operation (load upper immediate)
wire [31:0] lui_res = {a[15:0], 16'b0}; // MIPS LUI places immediate in upper 16 bits

// Default outputs
wire [31:0] default_res = 32'b0;
wire default_carry = 1'b0;
wire default_overflow = 1'b0;

// Select result based on aluc
wire [31:0] alu_r = 
    (aluc == ADD)  ? add_res[31:0]  :
    (aluc == ADDU) ? addu_res[31:0] :
    (aluc == SUB)  ? sub_res[31:0]  :
    (aluc == SUBU) ? subu_res[31:0] :
    (aluc == AND)  ? and_res         :
    (aluc == OR)   ? or_res          :
    (aluc == XOR)  ? xor_res         :
    (aluc == NOR)  ? nor_res         :
    (aluc == SLT)  ? {31'b0, slt_res} :
    (aluc == SLTU) ? {31'b0, sltu_res}:
    (aluc == SLL)  ? sll_res         :
    (aluc == SRL)  ? srl_res         :
    (aluc == SRA)  ? sra_res         :
    (aluc == SLLV) ? sllv_res        :
    (aluc == SRLV) ? srlv_res        :
    (aluc == SRAV) ? srav_res        :
    (aluc == LUI)  ? lui_res         :
                     default_res;

// Carry logic valid only for ADD/ADDU/SUB/SUBU
wire alu_carry = 
    (aluc == ADD)  ? add_res[32] :
    (aluc == ADDU) ? addu_res[32] :
    (aluc == SUB)  ? sub_res[32] :
    (aluc == SUBU) ? subu_res[32] :
    default_carry;

// Overflow detection for ADD and SUB (signed arithmetic)
wire alu_overflow = (aluc == ADD) ? 
                    ((~a[31] & ~b[31] & alu_r[31]) | (a[31] & b[31] & ~alu_r[31])) :
                    (aluc == SUB) ?
                    ((a[31] & ~b[31] & ~alu_r[31]) | (~a[31] & b[31] & alu_r[31])) :
                    1'b0;

// Negative flag from MSB of result
wire alu_negative = alu_r[31];

// Zero flag when result is all zeros
wire alu_zero = (alu_r == 32'b0);

// Flag set for SLT and SLTU only
wire alu_flag = (aluc == SLT) ? slt_res :
                (aluc == SLTU) ? sltu_res :
                1'bz; // high impedance as specified

// Output assignments
assign r = alu_r;
assign carry = alu_carry;
assign overflow = alu_overflow;
assign negative = alu_negative;
assign zero = alu_zero;
assign flag = alu_flag;

endmodule