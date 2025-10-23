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

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount wires
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Internal wires for carry and overflow (only valid for add/sub)
wire int_carry;
wire int_overflow;

// ALU result computed by combinational function
function [31:0] alu_compute;
    input [31:0] a_f;
    input [31:0] b_f;
    input [5:0]  op;
    reg [32:0] add_sub_res;
    reg carry_in;
    reg [31:0] b_operand;
    reg [31:0] result;
    reg signed [31:0] a_fs;
    reg signed [31:0] b_fs;
    begin
        a_fs = $signed(a_f);
        b_fs = $signed(b_f);
        carry_in = 1'b0;
        b_operand = b_f;
        result = 32'b0;
        case (op)
            ADD:  begin
                carry_in = 1'b0;
                b_operand = b_f;
                add_sub_res = {1'b0, a_f} + {1'b0, b_operand} + carry_in;
                result = add_sub_res[31:0];
            end
            ADDU: begin
                carry_in = 1'b0;
                b_operand = b_f;
                add_sub_res = {1'b0, a_f} + {1'b0, b_operand} + carry_in;
                result = add_sub_res[31:0];
            end
            SUB:  begin
                carry_in = 1'b1;
                b_operand = ~b_f;
                add_sub_res = {1'b0, a_f} + {1'b0, b_operand} + carry_in;
                result = add_sub_res[31:0];
            end
            SUBU: begin
                carry_in = 1'b1;
                b_operand = ~b_f;
                add_sub_res = {1'b0, a_f} + {1'b0, b_operand} + carry_in;
                result = add_sub_res[31:0];
            end
            AND:  result = a_f & b_f;
            OR:   result = a_f | b_f;
            XOR:  result = a_f ^ b_f;
            NOR:  result = ~(a_f | b_f);
            SLT:  result = (a_fs < b_fs) ? 32'b1 : 32'b0;
            SLTU: result = (a_f < b_f) ? 32'b1 : 32'b0;
            SLL:  result = b_f << shamt_imm;
            SRL:  result = b_f >> shamt_imm;
            SRA:  result = $signed(b_fs) >>> shamt_imm;
            SLLV: result = b_f << shamt_var;
            SRLV: result = b_f >> shamt_var;
            SRAV: result = $signed(b_fs) >>> shamt_var;
            LUI:  result = {a_f[15:0], 16'b0};
            default: result = 32'b0;
        endcase
        alu_compute = result;
    end
endfunction

// Compute the result combinationally
wire [31:0] alu_result = alu_compute(a, b, aluc);

// Compute carry and overflow only for ADD, ADDU, SUB, SUBU
// Carry out calculation for unsigned add/sub
wire [32:0] add_sub_calc;
wire carry_wire;
wire overflow_wire;

assign carry_wire = ( (aluc == ADDU) || (aluc == SUBU) ) ? (
                      ((aluc == ADDU) ? 
                         ( {1'b0, a} + {1'b0, b} ) :
                         ( {1'b0, a} + {1'b0, ~b} + 1'b1 )
                      )[32]
                   ) : 1'b0;

// Overflow detection for signed ADD and SUB
assign overflow_wire = (aluc == ADD) ? (
    ((a[31] == b[31]) && (alu_result[31] != a[31]))
) : ( (aluc == SUB) ? (
    ((a[31] != b[31]) && (alu_result[31] != a[31]))
) : 1'b0 );

// SLT and SLTU flags
wire slt_flag_wire  = (a_s < b_s);
wire sltu_flag_wire = (a < b);

// Flag output: 1 if SLT or SLTU and condition true, else 0
wire flag_wire = ((aluc == SLT) && slt_flag_wire) || ((aluc == SLTU) && sltu_flag_wire);

// Assign outputs
assign r = alu_result;
assign zero = (alu_result == 32'b0);
assign carry = carry_wire;
assign overflow = overflow_wire;
assign flag = flag_wire;
assign negative = alu_result[31];

endmodule