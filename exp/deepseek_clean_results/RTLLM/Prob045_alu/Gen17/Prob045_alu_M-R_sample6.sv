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

    // Common computations
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0]; // For *V operations
    
    // Operation results
    wire [31:0] add_result = (aluc == ADD || aluc == ADDU) ? add_res : 32'b0;
    wire [31:0] sub_result = (aluc == SUB || aluc == SUBU) ? sub_res : 32'b0;
    wire [31:0] and_result = (aluc == AND) ? (a & b) : 32'b0;
    wire [31:0] or_result  = (aluc == OR)  ? (a | b) : 32'b0;
    wire [31:0] xor_result = (aluc == XOR) ? (a ^ b) : 32'b0;
    wire [31:0] nor_result = (aluc == NOR) ? ~(a | b) : 32'b0;
    wire [31:0] slt_result = (aluc == SLT) ? ($signed(a) < $signed(b)) : 32'b0;
    wire [31:0] sltu_result= (aluc == SLTU)? (a < b) : 32'b0;
    wire [31:0] sll_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amt) : 32'b0;
    wire [31:0] srl_result = (aluc == SRL || aluc == SRLV) ? (b >> shift_amt) : 32'b0;
    wire [31:0] sra_result = (aluc == SRA || aluc == SRAV) ? ($signed(b) >>> shift_amt) : 32'b0;
    wire [31:0] lui_result = (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;

    // Result selection
    assign r = add_result | sub_result | and_result | or_result  |
               xor_result | nor_result | slt_result | sltu_result |
               sll_result | srl_result | sra_result | lui_result;

    // Flag generation
    assign carry = (aluc == ADD || aluc == ADDU) ? (add_res < a) :
                  (aluc == SUB || aluc == SUBU) ? (a < b) : 1'b0;
                  
    assign overflow = (aluc == ADD) ? (a[31] == b[31] && add_res[31] != a[31]) :
                     (aluc == SUB) ? (a[31] != b[31] && sub_res[31] != a[31]) : 1'b0;
                     
    assign negative = r[31];
    assign zero = (r == 0);
    assign flag = (aluc == SLT) ? slt_result[0] : 
                 (aluc == SLTU) ? sltu_result[0] : 1'b0;

endmodule