module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
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

// Signed operands for signed arithmetic
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Shift amounts
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Arithmetic full-width results
wire [32:0] add_full  = {a_signed[31], a_signed} + {b_signed[31], b_signed};
wire [32:0] addu_full = {1'b0, a} + {1'b0, b};
wire [32:0] sub_full  = {a_signed[31], a_signed} - {b_signed[31], b_signed};
wire [32:0] subu_full = {1'b0, a} - {1'b0, b};

// Logical results
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift results
wire [31:0] sll_res  = b << shamt_imm;
wire [31:0] srl_res  = b >> shamt_imm;
wire [31:0] sra_res  = $signed(b) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b) >>> shamt_var;

// LUI result (b upper 16 bits shifted, consistent with typical LUI)
wire [31:0] lui_res = {b[15:0], 16'b0};

// SLT and SLTU flags
wire slt_flag  = (a_signed < b_signed);
wire sltu_flag = (a < b);

// Result and flag wires (combinationally assigned)
wire [31:0] alu_res;
wire alu_carry;
wire alu_overflow;
wire alu_flag;

// Helper function to select outputs based on opcode
function [36:0] alu_compute; // 32 bits result + carry + overflow + flag
    input [31:0] a_in;
    input [31:0] b_in;
    input [5:0]  opcode;
    reg [32:0] add_r, addu_r, sub_r, subu_r;
    reg result_flag;
    reg carry_flag;
    reg overflow_flag;
    reg [31:0] result_val;
begin
    add_r  = {a_in[31], a_in} + {b_in[31], b_in};
    addu_r = {1'b0, a_in} + {1'b0, b_in};
    sub_r  = {a_in[31], a_in} - {b_in[31], b_in};
    subu_r = {1'b0, a_in} - {1'b0, b_in};
    result_flag = 1'b0;
    carry_flag = 1'b0;
    overflow_flag = 1'b0;
    result_val = 32'b0;

    case(opcode)
        ADD: begin
            result_val = add_r[31:0];
            carry_flag = add_r[32];
            overflow_flag = ((a_in[31] == b_in[31]) && (result_val[31] != a_in[31]));
        end
        ADDU: begin
            result_val = addu_r[31:0];
            carry_flag = addu_r[32];
            overflow_flag = 1'b0;
        end
        SUB: begin
            result_val = sub_r[31:0];
            carry_flag = (a_in >= b_in);
            overflow_flag = ((a_in[31] != b_in[31]) && (result_val[31] != a_in[31]));
        end
        SUBU: begin
            result_val = subu_r[31:0];
            carry_flag = (a_in >= b_in);
            overflow_flag = 1'b0;
        end
        AND:       result_val = a_in & b_in;
        OR:        result_val = a_in | b_in;
        XOR:       result_val = a_in ^ b_in;
        NOR:       result_val = ~(a_in | b_in);
        SLT: begin
            result_flag = ( $signed(a_in) < $signed(b_in) );
            result_val = 32'b0;
            result_val[0] = result_flag;
        end
        SLTU: begin
            result_flag = (a_in < b_in);
            result_val = 32'b0;
            result_val[0] = result_flag;
        end
        SLL:       result_val = b_in << a_in[4:0];
        SRL:       result_val = b_in >> a_in[4:0];
        SRA:       result_val = $signed(b_in) >>> a_in[4:0];
        SLLV:      result_val = b_in << a_in[4:0];
        SRLV:      result_val = b_in >> a_in[4:0];
        SRAV:      result_val = $signed(b_in) >>> a_in[4:0];
        LUI:       result_val = {b_in[15:0],16'b0};
        default: begin
            result_val = 32'b0;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
            result_flag = 1'b0;
        end
    endcase
    alu_compute = {result_flag, overflow_flag, carry_flag, result_val};
end
endfunction

wire [36:0] alu_out = alu_compute(a, b, aluc);

assign r        = alu_out[31:0];
assign carry    = alu_out[33];
assign overflow = alu_out[34];
assign flag     = alu_out[36];

// zero and negative flags
assign zero     = (r == 32'b0);
assign negative = r[31];

endmodule