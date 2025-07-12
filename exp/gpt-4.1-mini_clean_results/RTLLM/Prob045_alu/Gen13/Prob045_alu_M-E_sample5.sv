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

wire [4:0] shamt = a[4:0];

// Signed versions for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Precompute all possible operation results
wire [32:0] add_w = {1'b0, a} + {1'b0, b};  // 33-bit for carry out
wire [32:0] addu_w = {1'b0, a} + {1'b0, b};
wire [32:0] sub_w = {1'b0, a} - {1'b0, b};
wire [32:0] subu_w = {1'b0, a} - {1'b0, b};

wire [31:0] and_w = a & b;
wire [31:0] or_w  = a | b;
wire [31:0] xor_w = a ^ b;
wire [31:0] nor_w = ~(a | b);

wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);

wire [31:0] slt_w  = {31'b0, slt_flag};
wire [31:0] sltu_w = {31'b0, sltu_flag};

wire [31:0] sll_w  = b << shamt;
wire [31:0] srl_w  = b >> shamt;
wire [31:0] sra_w  = $signed(b_s) >>> shamt;

wire [31:0] sllv_w = b << a[4:0];
wire [31:0] srlv_w = b >> a[4:0];
wire [31:0] srav_w = $signed(b_s) >>> a[4:0];

wire [31:0] lui_w  = {b[15:0], 16'b0};

// Select result based on aluc
reg [31:0] r_reg;
always @* begin
    case (aluc)
        ADD:  r_reg = add_w[31:0];
        ADDU: r_reg = addu_w[31:0];
        SUB:  r_reg = sub_w[31:0];
        SUBU: r_reg = subu_w[31:0];
        AND:  r_reg = and_w;
        OR:   r_reg = or_w;
        XOR:  r_reg = xor_w;
        NOR:  r_reg = nor_w;
        SLT:  r_reg = slt_w;
        SLTU: r_reg = sltu_w;
        SLL:  r_reg = sll_w;
        SRL:  r_reg = srl_w;
        SRA:  r_reg = sra_w;
        SLLV: r_reg = sllv_w;
        SRLV: r_reg = srlv_w;
        SRAV: r_reg = srav_w;
        LUI:  r_reg = lui_w;
        default: r_reg = 32'b0;
    endcase
end

assign r = r_reg;

// zero flag: output result all zero
assign zero = (r == 32'b0);

// negative flag: MSB of output
assign negative = r[31];

// carry flag: meaningful only for ADD, ADDU, SUB, SUBU
wire carry_add = add_w[32];
wire carry_addu = addu_w[32];
wire carry_sub = sub_w[32];
wire carry_subu = subu_w[32];

assign carry = (aluc == ADD)  ? carry_add  :
               (aluc == ADDU) ? carry_addu :
               (aluc == SUB)  ? carry_sub  :
               (aluc == SUBU) ? carry_subu :
                                1'b0;

// overflow flag: only for signed ADD and SUB
wire overflow_add = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
wire overflow_sub = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);

assign overflow = (aluc == ADD) ? overflow_add :
                  (aluc == SUB) ? overflow_sub :
                  1'b0;

// flag output: only for SLT and SLTU
assign flag = (aluc == SLT)  ? slt_flag  :
              (aluc == SLTU) ? sltu_flag :
              1'b0;

endmodule