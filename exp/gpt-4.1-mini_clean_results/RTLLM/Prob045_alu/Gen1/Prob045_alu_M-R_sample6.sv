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

// Signed versions of inputs
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Shift amount from a[4:0]
wire [4:0] shamt = a[4:0];

// Arithmetic operations extended to 33 bits for carry/borrow detection
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] add_s_ext = {a[31], a} + {b[31], b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};
wire [32:0] sub_s_ext = {a[31], a} - {b[31], b};

// Individual results
wire [31:0] res_addu = add_ext[31:0];
wire        carry_addu = add_ext[32];
wire [31:0] res_add  = add_s_ext[31:0];
wire        carry_add = add_s_ext[32];
wire        overflow_add = (~a[31] & ~b[31] & res_add[31]) | (a[31] & b[31] & ~res_add[31]);

wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = sub_ext[32]; // borrow flag for unsigned
wire [31:0] res_sub  = sub_s_ext[31:0];
wire        carry_sub = sub_s_ext[32];
wire        overflow_sub = (a[31] & ~b[31] & ~res_sub[31]) | (~a[31] & b[31] & res_sub[31]);

wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

// SLT and SLTU
wire slt_flag = (a_s < b_s);
wire [31:0] res_slt  = slt_flag ? 32'd1 : 32'd0;

wire sltu_flag = (a < b);
wire [31:0] res_sltu = sltu_flag ? 32'd1 : 32'd0;

// Shifts
wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = $signed(b) >>> shamt;

wire [31:0] res_sllv = b << shamt;
wire [31:0] res_srlv = b >> shamt;
wire [31:0] res_srav = $signed(b) >>> shamt;

// LUI
wire [31:0] res_lui  = {b[15:0], 16'b0};

// Default outputs when no valid opcode
wire [31:0] res_default = 32'b0;

// MUX for output result r
reg [31:0] r_reg;
always @(*) begin
    case(aluc)
        ADD:  r_reg = res_add;
        ADDU: r_reg = res_addu;
        SUB:  r_reg = res_sub;
        SUBU: r_reg = res_subu;
        AND:  r_reg = res_and;
        OR:   r_reg = res_or;
        XOR:  r_reg = res_xor;
        NOR:  r_reg = res_nor;
        SLT:  r_reg = res_slt;
        SLTU: r_reg = res_sltu;
        SLL:  r_reg = res_sll;
        SRL:  r_reg = res_srl;
        SRA:  r_reg = res_sra;
        SLLV: r_reg = res_sllv;
        SRLV: r_reg = res_srlv;
        SRAV: r_reg = res_srav;
        LUI:  r_reg = res_lui;
        default: r_reg = res_default;
    endcase
end
assign r = r_reg;

// zero flag
assign zero = (r == 32'b0);

// negative flag
assign negative = r[31];

// carry flag: valid only for add/sub ops, zero otherwise
assign carry = (aluc == ADD)  ? carry_add  :
               (aluc == ADDU) ? carry_addu :
               (aluc == SUB)  ? carry_sub  :
               (aluc == SUBU) ? carry_subu :
               1'b0;

// overflow flag: valid only for signed add/sub, zero otherwise
assign overflow = (aluc == ADD) ? overflow_add :
                  (aluc == SUB) ? overflow_sub :
                  1'b0;

// flag output: 1 for SLT/SLTU when true, 0 otherwise
assign flag = (aluc == SLT)  ? slt_flag  :
              (aluc == SLTU) ? sltu_flag :
              1'b0;

endmodule