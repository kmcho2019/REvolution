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

// Function for addition with carry out and overflow detection
function [33:0] add_33;
    input [31:0] x, y;
    reg [32:0] sum_ext;
    begin
        sum_ext = {1'b0,x} + {1'b0,y};
        add_33 = {sum_ext[32], sum_ext[31:0]};
    end
endfunction

// Function for subtraction with carry out and overflow detection
function [33:0] sub_33;
    input [31:0] x, y;
    reg [32:0] diff_ext;
    begin
        diff_ext = {1'b0,x} - {1'b0,y};
        sub_33 = {diff_ext[32], diff_ext[31:0]};
    end
endfunction

// Compute additions and subtractions
wire [33:0] add_res  = add_33(a, b);
wire [33:0] addu_res = add_33(a, b);
wire [33:0] sub_res  = sub_33(a, b);
wire [33:0] subu_res = sub_33(a, b);

// Calculate overflow for signed ADD and SUB
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Compute other logic operations
wire [31:0] and_res  = a & b;
wire [31:0] or_res   = a | b;
wire [31:0] xor_res  = a ^ b;
wire [31:0] nor_res  = ~(a | b);

// Compute SLT and SLTU flags and result
wire slt_flag  = ($signed(a) < $signed(b));
wire sltu_flag = (a < b);
wire [31:0] slt_res  = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

// Compute shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];

// LUI operation: upper 16 bits of a concatenated with 16 zeros
wire [31:0] lui_res = {a[15:0], 16'b0};

// Default output
wire [31:0] default_res = 32'bz;

// Select the ALU result based on aluc
wire [31:0] alu_r = 
    (aluc == ADD)  ? add_res[31:0] :
    (aluc == ADDU) ? addu_res[31:0] :
    (aluc == SUB)  ? sub_res[31:0] :
    (aluc == SUBU) ? subu_res[31:0] :
    (aluc == AND)  ? and_res :
    (aluc == OR)   ? or_res :
    (aluc == XOR)  ? xor_res :
    (aluc == NOR)  ? nor_res :
    (aluc == SLT)  ? slt_res :
    (aluc == SLTU) ? sltu_res :
    (aluc == SLL)  ? sll_res :
    (aluc == SRL)  ? srl_res :
    (aluc == SRA)  ? sra_res :
    (aluc == SLLV) ? sllv_res :
    (aluc == SRLV) ? srlv_res :
    (aluc == SRAV) ? srav_res :
    (aluc == LUI)  ? lui_res :
                    default_res;

// Assign output result
assign r = alu_r;

// Assign zero flag
assign zero = (alu_r == 32'b0);

// Assign negative flag
assign negative = alu_r[31];

// Carry flag assignment based on operation
assign carry = 
    (aluc == ADD)  ? add_res[32] :
    (aluc == ADDU) ? addu_res[32] :
    (aluc == SUB)  ? sub_res[32] :
    (aluc == SUBU) ? subu_res[32] :
                    1'b0;

// Overflow flag assignment
assign overflow = 
    (aluc == ADD) ? add_overflow :
    (aluc == SUB) ? sub_overflow :
                   1'b0;

// Flag output: set for SLT and SLTU, otherwise 'z' (high impedance)
assign flag = (aluc == SLT) ? slt_flag :
              (aluc == SLTU) ? sltu_flag :
              1'bz;

endmodule