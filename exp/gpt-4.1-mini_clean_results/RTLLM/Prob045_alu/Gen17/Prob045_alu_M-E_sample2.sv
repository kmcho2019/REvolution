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

// Shift amounts
wire [4:0] shamt = a[4:0];       // for immediate shifts (SLL, SRL, SRA)
wire [4:0] shamt_v = a[4:0];     // variable shifts take shift amount from a[4:0]

// Signed versions for arithmetic ops
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Arithmetic additions with extended bits for carry detection
wire [32:0] add_res = {1'b0,a} + {1'b0,b};
wire [32:0] sub_res = {1'b0,a} - {1'b0,b};

// Results for each operation
wire [31:0] res_add  = add_res[31:0];
wire [31:0] res_addu = add_res[31:0];
wire [31:0] res_sub  = sub_res[31:0];
wire [31:0] res_subu = sub_res[31:0];
wire [31:0] res_and  = a & b;
wire [31:0] res_or   = a | b;
wire [31:0] res_xor  = a ^ b;
wire [31:0] res_nor  = ~(a | b);

// SLT and SLTU flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] res_slt  = {31'b0, slt_flag};
wire [31:0] res_sltu = {31'b0, sltu_flag};

// Shifts
wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = $signed(b) >>> shamt;

wire [31:0] res_sllv = b << shamt_v;
wire [31:0] res_srlv = b >> shamt_v;
wire [31:0] res_srav = $signed(b) >>> shamt_v;

// LUI (load upper immediate): shift a left 16
wire [31:0] res_lui = a << 16;

// Result multiplexer
reg [31:0] result_reg;
always @(*) begin
    case(aluc)
        ADD:  result_reg = res_add;
        ADDU: result_reg = res_addu;
        SUB:  result_reg = res_sub;
        SUBU: result_reg = res_subu;
        AND:  result_reg = res_and;
        OR:   result_reg = res_or;
        XOR:  result_reg = res_xor;
        NOR:  result_reg = res_nor;
        SLT:  result_reg = res_slt;
        SLTU: result_reg = res_sltu;
        SLL:  result_reg = res_sll;
        SRL:  result_reg = res_srl;
        SRA:  result_reg = res_sra;
        SLLV: result_reg = res_sllv;
        SRLV: result_reg = res_srlv;
        SRAV: result_reg = res_srav;
        LUI:  result_reg = res_lui;
        default: result_reg = 32'b0;
    endcase
end
assign r = result_reg;

// Zero flag
assign zero = (r == 32'b0);

// Negative flag (sign bit)
assign negative = r[31];

// Carry flag: only meaningful for ADD, ADDU, SUB, SUBU
// For ADD and ADDU carry out is add_res[32]
// For SUB and SUBU carry out is sub_res[32]
// For other ops carry is 0
assign carry = ( (aluc == ADD)  || (aluc == ADDU) ) ? add_res[32] :
               ( (aluc == SUB)  || (aluc == SUBU) ) ? sub_res[32] : 1'b0;

// Overflow detection only for ADD and SUB
// Overflow for addition: if a and b have same sign but result sign differs
wire overflow_add = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
// Overflow for subtraction: if signs of a and b differ and sign of result differs from a
wire overflow_sub = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);

assign overflow = (aluc == ADD) ? overflow_add :
                  (aluc == SUB) ? overflow_sub : 1'b0;

// Flag output is 1 for SLT and SLTU, else 0
assign flag = (aluc == SLT) ? slt_flag :
              (aluc == SLTU) ? sltu_flag : 1'b0;

endmodule