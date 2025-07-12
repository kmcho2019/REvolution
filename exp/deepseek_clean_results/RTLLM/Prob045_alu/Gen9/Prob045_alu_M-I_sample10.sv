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

    // Operation codes with one-hot encoding
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

    // Operation detection (one-hot style)
    wire is_add  = (aluc == ADD);
    wire is_addu = (aluc == ADDU);
    wire is_sub  = (aluc == SUB);
    wire is_subu = (aluc == SUBU);
    wire is_and  = (aluc == AND);
    wire is_or   = (aluc == OR);
    wire is_xor  = (aluc == XOR);
    wire is_nor  = (aluc == NOR);
    wire is_slt  = (aluc == SLT);
    wire is_sltu = (aluc == SLTU);
    wire is_sll  = (aluc == SLL);
    wire is_srl  = (aluc == SRL);
    wire is_sra  = (aluc == SRA);
    wire is_sllv = (aluc == SLLV);
    wire is_srlv = (aluc == SRLV);
    wire is_srav = (aluc == SRAV);
    wire is_lui  = (aluc == LUI);

    // Clock gating signals
    wire arith_en = is_add | is_addu | is_sub | is_subu;
    wire logic_en = is_and | is_or | is_xor | is_nor;
    wire shift_en = is_sll | is_srl | is_sra | is_sllv | is_srlv | is_srav;
    wire spec_en  = is_slt | is_sltu | is_lui;

    // Arithmetic Unit (Carry-select implementation)
    wire [31:0] arith_result;
    wire arith_carry, arith_overflow;
    
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    
    assign arith_result = (is_add | is_addu) ? add_res : sub_res;
    assign arith_carry = (is_add | is_addu) ? (a + b < a) : (a < b);
    assign arith_overflow = (is_add) ? (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]) :
                          (is_sub) ? (~a[31] & b[31] & sub_res[31]) | (a[31] & ~b[31] & ~sub_res[31]) : 1'b0;

    // Logical Unit (Resource shared implementation)
    wire [31:0] and_or = is_and ? (a & b) : (a | b);
    wire [31:0] xor_nor = is_xor ? (a ^ b) : ~(a | b);
    wire [31:0] logical_result = (is_and | is_or) ? and_or : xor_nor;

    // Shift Unit (Optimized barrel shifter)
    wire [4:0] shift_amount = (is_sllv | is_srlv | is_srav) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = (is_sll | is_sllv) ? b : 
                          (is_srl | is_srlv) ? b : 
                          $signed(b);
    wire [31:0] shift_result = 
        (is_sll | is_sllv) ? (shift_in << shift_amount) :
        (is_srl | is_srlv) ? (shift_in >> shift_amount) :
        (shift_in >>> shift_amount);

    // Special Operations
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] special_result = 
        is_slt  ? {31'b0, signed_a < signed_b} :
        is_sltu ? {31'b0, a < b} :
        {b[15:0], 16'b0};  // LUI

    // Result Selection (Direct muxing)
    assign r = (arith_en) ? arith_result :
              (logic_en) ? logical_result :
              (shift_en) ? shift_result :
              (spec_en)  ? special_result :
              32'b0;

    // Flag Generation (Optimized implementation)
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = arith_en ? arith_carry : 1'b0;
    assign overflow = (is_add | is_sub) ? arith_overflow : 1'b0;
    assign flag = is_slt ? (signed_a < signed_b) : 
                 is_sltu ? (a < b) : 1'b0;

    // Assertions for verification
    // synthesis translate_off
    always @(*) begin
        if (^aluc === 1'bx) $display("Warning: ALU control signal has X value");
        if (!(arith_en | logic_en | shift_en | spec_en)) 
            $display("Warning: Undefined ALU operation");
    end
    // synthesis translate_on

endmodule