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

// Shift amounts
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Arithmetic with carry out using 33-bit extended operands
wire [32:0] add_res = {1'b0,a} + {1'b0,b};
wire [32:0] addu_res = {1'b0,a} + {1'b0,b};
wire [32:0] sub_res = {1'b0,a} - {1'b0,b};
wire [32:0] subu_res = {1'b0,a} - {1'b0,b};

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Set less than
wire slt_flag = (a_s < b_s);
wire [31:0] slt_res = {31'b0, slt_flag};
wire sltu_flag = (a < b);
wire [31:0] sltu_res = {31'b0, sltu_flag};

// Shift operations
wire [31:0] sll_res = b << shamt_imm;
wire [31:0] srl_res = b >> shamt_imm;
wire [31:0] sra_res = $signed(b_s) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b_s) >>> shamt_var;

// LUI operation (shift upper 16 bits to high half, zero low half)
wire [31:0] lui_res = {a[15:0],16'b0};

// Default result for invalid opcode
wire [31:0] default_res = 32'b0;

// Result mux function
function [31:0] select_result;
    input [5:0] opcode;
    begin
        case (opcode)
            ADD:  select_result = add_res[31:0];
            ADDU: select_result = addu_res[31:0];
            SUB:  select_result = sub_res[31:0];
            SUBU: select_result = subu_res[31:0];
            AND:  select_result = and_res;
            OR:   select_result = or_res;
            XOR:  select_result = xor_res;
            NOR:  select_result = nor_res;
            SLT:  select_result = slt_res;
            SLTU: select_result = sltu_res;
            SLL:  select_result = sll_res;
            SRL:  select_result = srl_res;
            SRA:  select_result = sra_res;
            SLLV: select_result = sllv_res;
            SRLV: select_result = srlv_res;
            SRAV: select_result = srav_res;
            LUI:  select_result = lui_res;
            default: select_result = default_res;
        endcase
    end
endfunction

wire [31:0] alu_r = select_result(aluc);

// Carry flag only valid for ADD, ADDU, SUB, SUBU
wire alu_carry = (aluc == ADD)  ? add_res[32]  :
                 (aluc == ADDU) ? addu_res[32] :
                 (aluc == SUB)  ? sub_res[32]  :
                 (aluc == SUBU) ? subu_res[32] :
                 1'b0;

// Overflow flag only for signed ADD and SUB
wire alu_overflow = (aluc == ADD) ? 
        (~a[31] & ~b[31] & alu_r[31]) | (a[31] & b[31] & ~alu_r[31]) :
    (aluc == SUB) ? 
        (a[31] & ~b[31] & ~alu_r[31]) | (~a[31] & b[31] & alu_r[31]) :
    1'b0;

// Flag set only for SLT and SLTU instructions; otherwise 0
wire alu_flag = (aluc == SLT)  ? slt_flag :
                (aluc == SLTU) ? sltu_flag :
                1'b0;

// Zero and negative flags from final result
wire alu_zero = (alu_r == 32'b0);
wire alu_negative = alu_r[31];

assign r = alu_r;
assign carry = alu_carry;
assign overflow = alu_overflow;
assign flag = alu_flag;
assign zero = alu_zero;
assign negative = alu_negative;

endmodule