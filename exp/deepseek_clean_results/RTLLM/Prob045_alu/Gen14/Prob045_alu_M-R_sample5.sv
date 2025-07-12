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

    // Operation codes (unchanged)
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

    // Arithmetic operations
    wire is_add = (aluc == ADD) | (aluc == ADDU);
    wire is_sub = (aluc == SUB) | (aluc == SUBU);
    wire [32:0] arith_tmp = is_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
    wire [31:0] arith_result = arith_tmp[31:0];

    // Logic operations
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift operations
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];  // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_result =
        (aluc == SLL | aluc == SLLV)  ? (b << shift_amt) :
        (aluc == SRL | aluc == SRLV)  ? (b >> shift_amt) :
        (aluc == SRA | aluc == SRAV)  ? ($signed(b) >>> shift_amt) : 32'b0;

    // Comparison operations
    wire comp_result = 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Result selection
    assign r = 
        (aluc == ADD | aluc == ADDU | aluc == SUB | aluc == SUBU) ? arith_result :
        (aluc == AND | aluc == OR | aluc == XOR | aluc == NOR)    ? logic_result :
        (aluc == SLL | aluc == SRL | aluc == SRA | 
         aluc == SLLV | aluc == SRLV | aluc == SRAV)             ? shift_result :
        (aluc == SLT | aluc == SLTU)                              ? {31'b0, comp_result} :
        (aluc == LUI)                                             ? {b[15:0], 16'b0} :
        32'b0;

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = (is_add | is_sub) ? arith_tmp[32] : 1'b0;
    
    wire add_ovf = ~a[31] & ~b[31] & r[31];
    wire sub_ovf = (aluc == SUB) & ((~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]));
    assign overflow = (aluc == ADD) ? (a[31] & b[31] & ~r[31]) | add_ovf :
                     (aluc == SUB) ? sub_ovf : 1'b0;
    
    assign flag = (aluc == SLT | aluc == SLTU) ? comp_result : 1'b0;

endmodule