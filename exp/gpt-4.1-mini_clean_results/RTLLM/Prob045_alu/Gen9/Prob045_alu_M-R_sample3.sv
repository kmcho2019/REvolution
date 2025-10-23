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

// Arithmetic: extend to 33 bits for carry detection
wire [32:0] add_res = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

// Flags for overflow detection on signed add
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
// Flags for overflow detection on signed sub
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Logic results
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// SLT and SLTU flags and results
wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res = {31'd0, slt_flag};
wire [31:0] sltu_res = {31'd0, sltu_flag};

// Shift amounts
wire [4:0] shamt_var = a[4:0];
wire [31:0] sll_res = b << shamt;
wire [31:0] srl_res = b >> shamt;
wire [31:0] sra_res = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b_s) >>> shamt_var;

// LUI operation result
wire [31:0] lui_res = {a[15:0], 16'd0};

// Result mux
reg [31:0] r_reg;
always @(*) begin
    case (aluc)
        ADD:  r_reg = add_res[31:0];
        ADDU: r_reg = addu_res[31:0];
        SUB:  r_reg = sub_res[31:0];
        SUBU: r_reg = subu_res[31:0];
        AND:  r_reg = and_res;
        OR:   r_reg = or_res;
        XOR:  r_reg = xor_res;
        NOR:  r_reg = nor_res;
        SLT:  r_reg = slt_res;
        SLTU: r_reg = sltu_res;
        SLL:  r_reg = sll_res;
        SRL:  r_reg = srl_res;
        SRA:  r_reg = sra_res;
        SLLV: r_reg = sllv_res;
        SRLV: r_reg = srlv_res;
        SRAV: r_reg = srav_res;
        LUI:  r_reg = lui_res;
        default: r_reg = 32'b0;
    endcase
end

assign r = r_reg;
assign zero = (r_reg == 32'b0);
assign negative = r_reg[31];

// Carry is meaningful only for ADD, ADDU, SUB, SUBU
assign carry = (aluc == ADD)  ? add_res[32]  :
               (aluc == ADDU) ? addu_res[32] :
               (aluc == SUB)  ? sub_res[32]  :
               (aluc == SUBU) ? subu_res[32] : 1'b0;

// Overflow only for signed ADD and SUB
assign overflow = (aluc == ADD) ? add_overflow :
                  (aluc == SUB) ? sub_overflow : 1'b0;

// Flag is set only for SLT and SLTU, else zero
assign flag = (aluc == SLT)  ? slt_flag  :
              (aluc == SLTU) ? sltu_flag : 1'b0;

endmodule