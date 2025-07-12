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

    // Shared adder/subtractor result
    wire [32:0] add_sub_result = {1'b0, a} + {1'b0, (aluc[0] ? ~b : b)} + aluc[0];
    wire [31:0] adder_out = add_sub_result[31:0];

    // Shift amount selection
    wire [4:0] shift_amt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];

    // Operation result selection
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? adder_out :
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        (aluc == SLL || aluc == SLLV) ? b << shift_amt :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amt :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amt :
        32'b0;

    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? 
                  add_sub_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) || (aluc == SUB)) ? 
                     (add_sub_result[32] ^ add_sub_result[31]) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule