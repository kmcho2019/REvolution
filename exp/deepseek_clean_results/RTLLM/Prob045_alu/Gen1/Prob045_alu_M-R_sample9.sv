module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Operation codes
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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] unsigned_a = a;
    wire [31:0] unsigned_b = b;
    wire [4:0] shamt = b[4:0];
    
    // Arithmetic operations
    wire [32:0] add_res = {signed_a[31], signed_a} + {signed_b[31], signed_b};
    wire [32:0] addu_res = {1'b0, unsigned_a} + {1'b0, unsigned_b};
    wire [32:0] sub_res = {signed_a[31], signed_a} - {signed_b[31], signed_b};
    wire [32:0] subu_res = {1'b0, unsigned_a} - {1'b0, unsigned_b};
    
    // Shift operations
    wire [31:0] sll_res = b << shamt;
    wire [31:0] srl_res = b >> shamt;
    wire [31:0] sra_res = $signed(b) >>> shamt;
    wire [31:0] sllv_res = b << a[4:0];
    wire [31:0] srlv_res = b >> a[4:0];
    wire [31:0] srav_res = $signed(b) >>> a[4:0];
    
    // Result selection
    assign r = 
        (aluc == ADD)  ? add_res[31:0] :
        (aluc == ADDU) ? addu_res[31:0] :
        (aluc == SUB)  ? sub_res[31:0] :
        (aluc == SUBU) ? subu_res[31:0] :
        (aluc == AND)  ? (a & b) :
        (aluc == OR)   ? (a | b) :
        (aluc == XOR)  ? (a ^ b) :
        (aluc == NOR)  ? ~(a | b) :
        (aluc == SLT)  ? {31'b0, (signed_a < signed_b)} :
        (aluc == SLTU) ? {31'b0, (unsigned_a < unsigned_b)} :
        (aluc == SLL)  ? sll_res :
        (aluc == SRL)  ? srl_res :
        (aluc == SRA)  ? sra_res :
        (aluc == SLLV) ? sllv_res :
        (aluc == SRLV) ? srlv_res :
        (aluc == SRAV) ? srav_res :
        (aluc == LUI)  ? {b[15:0], 16'b0} :
        32'bz;
    
    // Flag outputs
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = 
        (aluc == ADD)  ? add_res[32] :
        (aluc == ADDU) ? addu_res[32] :
        (aluc == SUB)  ? sub_res[32] :
        (aluc == SUBU) ? subu_res[32] :
        1'b0;
    
    assign overflow = 
        (aluc == ADD) ? ((signed_a[31] == signed_b[31]) && (add_res[31] != signed_a[31])) :
        (aluc == SUB) ? ((signed_a[31] != signed_b[31]) && (sub_res[31] != signed_a[31])) :
        1'b0;
    
    assign flag = 
        (aluc == SLT)  ? (signed_a < signed_b) :
        (aluc == SLTU) ? (unsigned_a < unsigned_b) :
        1'bz;

endmodule