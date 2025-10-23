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

    // Operation type detection
    wire is_arith = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Parallel execution units
    // Arithmetic Unit
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [32:0] arith_add = (aluc == ADD || aluc == ADDU) ? (a + b) : 
                           (aluc == SUB || aluc == SUBU) ? (a - b) : 33'b0;
    
    // Logic Unit
    wire [31:0] logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;
    
    // Shift Unit with optimized barrel shifter
    wire [4:0] shift_amt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shift_res = 
        (aluc == SLL || aluc == SLLV) ? (b << shift_amt) :
        (aluc == SRL || aluc == SRLV) ? (b >> shift_amt) :
        (aluc == SRA || aluc == SRAV) ? ($signed(b) >>> shift_amt) : 32'b0;
    
    // Comparison Unit
    wire comp_res = 
        (aluc == SLT) ? (signed_a < signed_b) :
        (aluc == SLTU) ? (a < b) : 1'b0;
    
    // LUI Unit
    wire [31:0] lui_res = {b[15:0], 16'b0};
    
    // Result selection
    assign r = 
        is_arith ? arith_add[31:0] :
        is_logic ? logic_res :
        is_shift ? shift_res :
        is_comp ? {31'b0, comp_res} :
        is_lui ? lui_res : 32'bz;
    
    // Flag generation (computed in parallel)
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? arith_add[32] : 1'b0;
    
    // Overflow detection
    wire add_ovf = (signed_a[31] == signed_b[31]) && (arith_add[31] != signed_a[31]);
    wire sub_ovf = (signed_a[31] != signed_b[31]) && (arith_add[31] != signed_a[31]);
    assign overflow = 
        (aluc == ADD) ? add_ovf :
        (aluc == SUB) ? sub_ovf : 1'b0;
    
    // Flag output (only valid for comparison ops)
    assign flag = is_comp ? comp_res : 1'bz;

endmodule