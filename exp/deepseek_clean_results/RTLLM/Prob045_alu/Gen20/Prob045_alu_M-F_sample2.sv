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

    // Operation classification
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_bitwise = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_compare = (aluc == SLT || aluc == SLTU);
    wire do_sub = (aluc == SUB || aluc == SUBU || aluc == SLT || aluc == SLTU);

    // Arithmetic Unit (optimized separate paths)
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} + {1'b0, ~b} + 33'b1;
    wire [32:0] arith_result = do_sub ? sub_result : add_result;

    // Barrel Shifter (logarithmic implementation)
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);  // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_result;
    assign shift_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amount) :
                         (aluc == SRL || aluc == SRLV) ? (b >> shift_amount) :
                         ($signed(b) >>> shift_amount);  // SRA/SRAV

    // Bitwise Operations (shared logic)
    wire [31:0] bitwise_result;
    assign bitwise_result = (aluc == AND) ? (a & b) :
                           (aluc == OR)  ? (a | b) :
                           (aluc == XOR) ? (a ^ b) :
                           ~(a | b);  // NOR

    // Main Result
    assign r = is_arith ? arith_result[31:0] :
               is_bitwise ? bitwise_result :
               is_compare ? {31'b0, (aluc == SLT) ? arith_result[31] : arith_result[32]} :
               is_shift ? shift_result :
               (aluc == LUI) ? {b[15:0], 16'b0} :
               32'b0;

    // Flags (gated computation)
    assign zero = (r == 32'b0);
    assign carry = is_arith ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD || aluc == SUB) && 
                     (a[31] == (do_sub ? ~b[31] : b[31])) && 
                     (arith_result[31] != a[31]);
    assign flag = is_compare ? ((aluc == SLT) ? arith_result[31] : arith_result[32]) : 1'b0;

endmodule