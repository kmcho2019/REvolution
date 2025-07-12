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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

wire [4:0] shamt = a[4:0];

// Intermediate results for each operation
wire [32:0] add_res = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);
wire [31:0] sll_res = b << shamt;
wire [31:0] srl_res = b >> shamt;
wire [31:0] sra_res = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];
wire [31:0] lui_res = {a[15:0], 16'b0};

wire [31:0] slt_res  = (a_s < b_s) ? 32'b1 : 32'b0;
wire [31:0] sltu_res = (a < b) ? 32'b1 : 32'b0;

// Result mux
wire [31:0] r_wire = 
    (aluc == ADD)  ? add_res[31:0]  :
    (aluc == ADDU) ? addu_res[31:0] :
    (aluc == SUB)  ? sub_res[31:0]  :
    (aluc == SUBU) ? subu_res[31:0] :
    (aluc == AND)  ? and_res         :
    (aluc == OR)   ? or_res          :
    (aluc == XOR)  ? xor_res         :
    (aluc == NOR)  ? nor_res         :
    (aluc == SLT)  ? slt_res         :
    (aluc == SLTU) ? sltu_res        :
    (aluc == SLL)  ? sll_res         :
    (aluc == SRL)  ? srl_res         :
    (aluc == SRA)  ? sra_res         :
    (aluc == SLLV) ? sllv_res        :
    (aluc == SRLV) ? srlv_res        :
    (aluc == SRAV) ? srav_res        :
    (aluc == LUI)  ? lui_res         :
    32'bz;  // High impedance for undefined

assign r = r_wire;

// Carry flag only valid for ADD, ADDU, SUB, SUBU
assign carry = (aluc == ADD)  ? add_res[32] :
               (aluc == ADDU) ? addu_res[32] :
               (aluc == SUB)  ? sub_res[32] :
               (aluc == SUBU) ? subu_res[32] :
               1'b0;

// Overflow detection for signed add/sub
assign overflow = (aluc == ADD) ? 
    (~a[31] & ~b[31] & r_wire[31]) | (a[31] & b[31] & ~r_wire[31]) :
    (aluc == SUB) ?
    (a[31] & ~b[31] & ~r_wire[31]) | (~a[31] & b[31] & r_wire[31]) :
    1'b0;

// Negative flag based on MSB of result
assign negative = r_wire[31];

// Zero flag if result is zero
assign zero = (r_wire == 32'b0);

// Flag is '1' for SLT and SLTU instructions, else 'z' (high impedance)
assign flag = (aluc == SLT)  ? 1'b1 :
              (aluc == SLTU) ? 1'b1 :
              1'bz;

endmodule