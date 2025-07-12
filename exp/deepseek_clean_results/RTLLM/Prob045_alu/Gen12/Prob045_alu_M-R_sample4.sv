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

    // Internal operation results
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    wire [31:0] and_res = a & b;
    wire [31:0] or_res  = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);
    
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire signed [31:0] signed_b = b;
    wire [31:0] sll_res = b << shift_amt;
    wire [31:0] srl_res = b >> shift_amt;
    wire [31:0] sra_res = signed_b >>> shift_amt;
    
    wire slt_res  = $signed(a) < $signed(b);
    wire sltu_res = a < b;
    wire [31:0] lui_res = {b[15:0], 16'b0};

    // Result selection
    wire [31:0] arith_res = 
        (aluc == ADD || aluc == ADDU) ? add_res[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_res[31:0] : 32'b0;
    
    wire [31:0] logic_res =
        (aluc == AND) ? and_res :
        (aluc == OR)  ? or_res  :
        (aluc == XOR) ? xor_res :
        (aluc == NOR) ? nor_res : 32'b0;
    
    wire [31:0] shift_res =
        (aluc == SLL || aluc == SLLV) ? sll_res :
        (aluc == SRL || aluc == SRLV) ? srl_res :
        (aluc == SRA || aluc == SRAV) ? sra_res : 32'b0;
    
    wire [31:0] comp_res = 
        (aluc == SLT)  ? {31'b0, slt_res}  :
        (aluc == SLTU) ? {31'b0, sltu_res} : 32'b0;
    
    // Final result
    wire [31:0] result = 
        (aluc[5:4] == 2'b10) ? (aluc[2] ? comp_res : arith_res) :
        (aluc[5:3] == 3'b000) ? shift_res :
        (aluc == LUI) ? lui_res :
        logic_res;

    // Flag generation
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_res[32] :
        (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    assign overflow =
        (aluc == ADD) ? (~a[31] & ~b[31] & result[31]) | (a[31] & b[31] & ~result[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & result[31]) | (a[31] & ~b[31] & ~result[31]) : 1'b0;
    assign flag = 
        (aluc == SLT)  ? slt_res  :
        (aluc == SLTU) ? sltu_res : 1'b0;

    // Output
    assign r = result;

endmodule