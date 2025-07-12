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
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Arithmetic extended for carry
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};

// Intermediate results
wire [31:0] res_add  = add_ext[31:0];
wire        carry_add = add_ext[32];
wire        overflow_add = (~a[31] & ~b[31] & res_add[31]) | (a[31] & b[31] & ~res_add[31]);

wire [31:0] res_addu  = add_ext[31:0];
wire        carry_addu = add_ext[32];
wire        overflow_addu = 1'b0;

wire [31:0] res_sub  = sub_ext[31:0];
wire        carry_sub = sub_ext[32];
wire        overflow_sub = (a[31] & ~b[31] & ~res_sub[31]) | (~a[31] & b[31] & res_sub[31]);

wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = sub_ext[32];
wire        overflow_subu = 1'b0;

wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

wire        flag_slt  = (a_s < b_s);
wire [31:0] res_slt   = {31'b0, flag_slt};

wire        flag_sltu = (a < b);
wire [31:0] res_sltu  = {31'b0, flag_sltu};

wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = $signed(b) >>> shamt;

wire [31:0] res_sllv = b << shamt;
wire [31:0] res_srlv = b >> shamt;
wire [31:0] res_srav = $signed(b) >>> shamt;

wire [31:0] res_lui  = a << 16;

// Selector for result
function [31:0] select_result(input [5:0] op);
    begin
        case (op)
            ADD:  select_result = res_add;
            ADDU: select_result = res_addu;
            SUB:  select_result = res_sub;
            SUBU: select_result = res_subu;
            AND:  select_result = res_and;
            OR:   select_result = res_or;
            XOR:  select_result = res_xor;
            NOR:  select_result = res_nor;
            SLT:  select_result = res_slt;
            SLTU: select_result = res_sltu;
            SLL:  select_result = res_sll;
            SRL:  select_result = res_srl;
            SRA:  select_result = res_sra;
            SLLV: select_result = res_sllv;
            SRLV: select_result = res_srlv;
            SRAV: select_result = res_srav;
            LUI:  select_result = res_lui;
            default: select_result = 32'b0;
        endcase
    end
endfunction

wire [31:0] result = select_result(aluc);

// Carry signal: valid only for arithmetic ops
wire carry_wire = 
    (aluc == ADD)  ? carry_add  :
    (aluc == ADDU) ? carry_addu :
    (aluc == SUB)  ? carry_sub  :
    (aluc == SUBU) ? carry_subu :
    1'b0;

// Overflow signal: valid only for signed add/sub
wire overflow_wire = 
    (aluc == ADD) ? overflow_add :
    (aluc == SUB) ? overflow_sub :
    1'b0;

// Negative flag: sign bit of result
wire negative_wire = result[31];

// Zero flag: result equals zero
wire zero_wire = (result == 32'b0);

// Flag output: only set for SLT and SLTU, else zero
wire flag_wire = (aluc == SLT) ? flag_slt : (aluc == SLTU) ? flag_sltu : 1'b0;

assign r        = result;
assign carry    = carry_wire;
assign overflow = overflow_wire;
assign negative = negative_wire;
assign zero     = zero_wire;
assign flag     = flag_wire;

endmodule