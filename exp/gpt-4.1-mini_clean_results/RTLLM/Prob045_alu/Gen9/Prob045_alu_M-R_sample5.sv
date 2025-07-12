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

// Add and Sub results with carry and overflow detection
wire [32:0] add_res = {1'b0,a} + {1'b0,b};
wire [32:0] addu_res = {1'b0,a} + {1'b0,b};
wire [32:0] sub_res = {1'b0,a} - {1'b0,b};
wire [32:0] subu_res = {1'b0,a} - {1'b0,b};

// Overflow detection for ADD
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
// Overflow detection for SUB
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

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

// LUI operation: concatenate lower 16 bits of a with 16 zeros (problem statement ambiguity is resolved here as lower 16 bits)
wire [31:0] lui_res = {a[15:0], 16'b0};

// Result mux
wire [31:0] r_internal = 
    (aluc == ADD)  ? add_res[31:0]  :
    (aluc == ADDU) ? addu_res[31:0] :
    (aluc == SUB)  ? sub_res[31:0]  :
    (aluc == SUBU) ? subu_res[31:0] :
    (aluc == AND)  ? and_res        :
    (aluc == OR)   ? or_res         :
    (aluc == XOR)  ? xor_res        :
    (aluc == NOR)  ? nor_res        :
    (aluc == SLT)  ? slt_res        :
    (aluc == SLTU) ? sltu_res       :
    (aluc == SLL)  ? sll_res        :
    (aluc == SRL)  ? srl_res        :
    (aluc == SRA)  ? sra_res        :
    (aluc == SLLV) ? sllv_res       :
    (aluc == SRLV) ? srlv_res       :
    (aluc == SRAV) ? srav_res       :
    (aluc == LUI)  ? lui_res        :
                     32'bz;

// Flags mux
wire carry_internal =
    (aluc == ADD)  ? add_res[32]  :
    (aluc == ADDU) ? addu_res[32] :
    (aluc == SUB)  ? sub_res[32]  :
    (aluc == SUBU) ? subu_res[32] :
                    1'b0;

wire overflow_internal =
    (aluc == ADD) ? add_overflow :
    (aluc == SUB) ? sub_overflow :
                   1'b0;

wire flag_internal = 
    (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz; // high-impedance when not SLT/SLTU, per problem statement

assign r = r_internal;
assign carry = carry_internal;
assign overflow = overflow_internal;
assign zero = (r_internal == 32'b0);
assign negative = r_internal[31];
assign flag = flag_internal;

endmodule