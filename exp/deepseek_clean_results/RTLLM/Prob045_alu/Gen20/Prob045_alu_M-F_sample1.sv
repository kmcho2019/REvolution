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
    wire arith_op = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU || 
                    aluc == SLT || aluc == SLTU);
    wire bitwise_op = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire shift_op = (aluc == SLL || aluc == SRL || aluc == SRA || 
                   aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire do_sub = (aluc == SUB || aluc == SUBU || aluc == SLT || aluc == SLTU);

    // Arithmetic Unit (optimized separate paths)
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} + {1'b0, ~b} + 33'b1;
    wire [32:0] arith_result = do_sub ? sub_result : add_result;

    // Logarithmic Barrel Shifter
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);  // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_stage1 = (shift_amount[0] ? (aluc[1] ? ($signed(b) >>> 1) : (b >> 1)) : b);
    wire [31:0] shift_stage2 = (shift_amount[1] ? (aluc[1] ? ($signed(shift_stage1) >>> 2) : (shift_stage1 >> 2)) : shift_stage1);
    wire [31:0] shift_stage4 = (shift_amount[2] ? (aluc[1] ? ($signed(shift_stage2) >>> 4) : (shift_stage2 >> 4)) : shift_stage2);
    wire [31:0] shift_stage8 = (shift_amount[3] ? (aluc[1] ? ($signed(shift_stage4) >>> 8) : (shift_stage4 >> 8)) : shift_stage4);
    wire [31:0] shift_stage16 = (shift_amount[4] ? (aluc[1] ? ($signed(shift_stage8) >>> 16) : (shift_stage8 >> 16)) : shift_stage8);
    wire [31:0] shift_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amount) : shift_stage16;

    // Main Result
    assign r = 
        arith_op ? arith_result[31:0] :
        bitwise_op ? 
            (aluc == AND) ? (a & b) :
            (aluc == OR)  ? (a | b) :
            (aluc == XOR) ? (a ^ b) :
            ~(a | b) :  // NOR
        shift_op ? shift_result :
        (aluc == SLT) ? {31'b0, arith_result[31]} :
        (aluc == SLTU) ? {31'b0, arith_result[32]} :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0;

    // Flags (conditionally generated)
    assign zero = (r == 32'b0);
    assign carry = arith_op ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = arith_op && (aluc == ADD || aluc == SUB) && 
                     (a[31] == (do_sub ? ~b[31] : b[31])) && 
                     (arith_result[31] != a[31]);
    assign flag = (aluc == SLT) ? arith_result[31] :
                 (aluc == SLTU) ? arith_result[32] : 1'b0;

endmodule