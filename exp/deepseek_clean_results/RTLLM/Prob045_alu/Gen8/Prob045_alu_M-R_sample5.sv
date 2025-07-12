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
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = (aluc[3] & ~aluc[1]) ? a[4:0] : b[4:0]; // For SxLV ops
    
    // Arithmetic units
    wire [32:0] adder_out = {1'b0, a} + {1'b0, b};
    wire [32:0] subber_out = {1'b0, a} - {1'b0, b};
    wire [32:0] arith_result = (aluc[0] ? subber_out : adder_out);
    
    // Shift operations
    wire [31:0] sll_out = b << shift_amount;
    wire [31:0] srl_out = b >> shift_amount;
    wire [31:0] sra_out = $signed(b) >>> shift_amount;
    wire [31:0] shift_result = (aluc[1:0] == 2'b00) ? sll_out :
                              (aluc[1:0] == 2'b10) ? srl_out : sra_out;
    
    // Comparison results
    wire slt_result = a_signed < b_signed;
    wire sltu_result = a < b;
    
    // Main result multiplexer
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_result[31:0] :
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        ((aluc == SLL) || (aluc == SLLV)) ? sll_out :
        ((aluc == SRL) || (aluc == SRLV)) ? srl_out :
        ((aluc == SRA) || (aluc == SRAV)) ? sra_out :
        32'b0;
    
    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = arith_result[32] & (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    assign negative = r[31];
    assign overflow = (~a[31] & ~b[31] & r[31] & (aluc == ADD)) | 
                     (a[31] & b[31] & ~r[31] & (aluc == ADD)) |
                     (~a[31] & b[31] & r[31] & (aluc == SUB)) |
                     (a[31] & ~b[31] & ~r[31] & (aluc == SUB));
    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result :
                 1'b0;

endmodule