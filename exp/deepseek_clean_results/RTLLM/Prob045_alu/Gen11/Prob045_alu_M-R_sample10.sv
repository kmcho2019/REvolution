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

    // Operation enable signals
    wire op_add  = (aluc == ADD);
    wire op_addu = (aluc == ADDU);
    wire op_sub  = (aluc == SUB);
    wire op_subu = (aluc == SUBU);
    wire op_and  = (aluc == AND);
    wire op_or   = (aluc == OR);
    wire op_xor  = (aluc == XOR);
    wire op_nor  = (aluc == NOR);
    wire op_slt  = (aluc == SLT);
    wire op_sltu = (aluc == SLTU);
    wire op_sll  = (aluc == SLL);
    wire op_srl  = (aluc == SRL);
    wire op_sra  = (aluc == SRA);
    wire op_sllv = (aluc == SLLV);
    wire op_srlv = (aluc == SRLV);
    wire op_srav = (aluc == SRAV);
    wire op_lui  = (aluc == LUI);

    // Arithmetic operations
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    wire [31:0] arith_res = 
        (op_add | op_addu) ? add_res[31:0] :
        (op_sub | op_subu) ? sub_res[31:0] : 32'b0;

    // Logical operations
    wire [31:0] logic_res =
        op_and ? (a & b) :
        op_or  ? (a | b) :
        op_xor ? (a ^ b) :
        op_nor ? ~(a | b) : 32'b0;

    // Shift operations
    wire [4:0] shift_amt = (op_sllv | op_srlv | op_srav) ? a[4:0] : b[4:0];
    wire [31:0] shift_res =
        op_sll  ? (b << shift_amt) :
        op_sllv ? (b << shift_amt) :
        op_srl  ? (b >> shift_amt) :
        op_srlv ? (b >> shift_amt) :
        op_sra  ? ($signed(b) >>> shift_amt) :
        op_srav ? ($signed(b) >>> shift_amt) : 32'b0;

    // Comparison operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [31:0] comp_res = 
        op_slt  ? {31'b0, (a_signed < b_signed)} :
        op_sltu ? {31'b0, (a < b)} : 32'b0;

    // LUI operation
    wire [31:0] lui_res = {b[15:0], 16'b0};

    // Result selection
    assign r = 
        (op_add | op_addu | op_sub | op_subu) ? arith_res :
        (op_and | op_or | op_xor | op_nor) ? logic_res :
        (op_sll | op_srl | op_sra | op_sllv | op_srlv | op_srav) ? shift_res :
        (op_slt | op_sltu) ? comp_res :
        op_lui ? lui_res : 32'b0;

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = 
        (op_add | op_addu) ? add_res[32] :
        (op_sub | op_subu) ? sub_res[32] : 1'b0;
    assign overflow =
        op_add ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        op_sub ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 1'b0;
    assign flag = 
        op_slt ? (a_signed < b_signed) :
        op_sltu ? (a < b) : 1'b0;

endmodule