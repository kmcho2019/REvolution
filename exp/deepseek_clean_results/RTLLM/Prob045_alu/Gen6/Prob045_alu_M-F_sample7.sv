module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
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
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // Only for SLLV/SRLV/SRAV
    
    // Operation decoding
    wire do_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire do_shift = (aluc[5:3] == 3'b000);
    wire do_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire do_comp = (aluc == SLT || aluc == SLTU);

    // Optimized arithmetic unit with early muxing
    wire [31:0] arith_b = is_sub ? ~b : b;
    wire [32:0] arith_res = {1'b0, a} + {1'b0, arith_b} + {32'b0, is_sub};
    wire arith_ovf = ~is_sub ? (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]) :
                                (~a[31] & b[31] & arith_res[31]) | (a[31] & ~b[31] & ~arith_res[31]);

    // Hierarchical barrel shifter (5 stages)
    wire [31:0] shift_stage1 = (shift_amount[0]) ? (aluc[1] ? {{1{b[31]}}, b[31:1]} : {1'b0, b[31:1]}) : b;
    wire [31:0] shift_stage2 = (shift_amount[1]) ? (aluc[1] ? {{2{shift_stage1[31]}}, shift_stage1[31:2]} : {2'b0, shift_stage1[31:2]}) : shift_stage1;
    wire [31:0] shift_stage3 = (shift_amount[2]) ? (aluc[1] ? {{4{shift_stage2[31]}}, shift_stage2[31:4]} : {4'b0, shift_stage2[31:4]}) : shift_stage2;
    wire [31:0] shift_stage4 = (shift_amount[3]) ? (aluc[1] ? {{8{shift_stage3[31]}}, shift_stage3[31:8]} : {8'b0, shift_stage3[31:8]}) : shift_stage3;
    wire [31:0] shift_result = (shift_amount[4]) ? (aluc[1] ? {{16{shift_stage4[31]}}, shift_stage4[31:16]} : {16'b0, shift_stage4[31:16]}) : shift_stage4;

    // Shared logic operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res = a | b;
    wire [31:0] logic_res = (aluc == AND) ? and_res :
                           (aluc == OR)  ? or_res :
                           (aluc == XOR) ? a ^ b :
                           ~or_res; // NOR

    // Comparison result
    wire comparison = (aluc == SLT) ? (a_signed < b_signed) : (a < b);

    always @(*) begin
        case (1'b1)
            do_arith: r = arith_res[31:0];
            do_shift: r = shift_result;
            do_logic: r = logic_res;
            do_comp:  r = {31'b0, comparison};
            (aluc == LUI): r = {b[15:0], 16'b0};
            default:   r = 32'b0;
        endcase

        // Flag output only for comparison ops
        flag = do_comp ? comparison : 1'b0;
    end

    // Output assignments
    assign zero = ~|r;
    assign carry = do_arith ? arith_res[32] : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? arith_ovf : 1'b0;

endmodule