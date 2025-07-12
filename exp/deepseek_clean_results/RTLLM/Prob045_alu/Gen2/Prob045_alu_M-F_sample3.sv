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
    wire [31:0] a_signed = $signed(a);
    wire [31:0] b_signed = $signed(b);
    wire [32:0] arith_res;
    wire [31:0] logic_res, shift_res, comp_res;
    wire [31:0] result_bus;
    wire [4:0] shift_amount;
    wire is_signed_arith;
    wire is_compare;

    // Operation classification
    assign is_signed_arith = (aluc == ADD || aluc == SUB);
    assign is_compare = (aluc == SLT || aluc == SLTU);

    // Optimized Arithmetic Unit
    assign arith_res = 
        is_signed_arith ? 
            (aluc == ADD ? a_signed + b_signed : a_signed - b_signed) :
            (aluc == ADDU || aluc == ADD ? a + b : a - b);

    // Optimized Logic Unit
    assign logic_res = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Unified Shifter with consolidated control
    assign shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    assign shift_res = 
        (aluc == SLL || aluc == SLLV)  ? b << shift_amount :
        (aluc == SRL || aluc == SRLV)  ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV)  ? $signed(b) >>> shift_amount :
        {b[15:0], 16'b0};  // LUI

    // Combined Comparison Logic
    assign comp_res = {31'b0, 
        (aluc == SLT) ? (a_signed < b_signed) : (a < b)};

    // Result selection
    assign result_bus = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_res :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_res :
        (aluc[5:3] == 3'b000) ? shift_res : 
        (is_compare) ? comp_res : 32'b0;

    // Balanced Zero Detection Tree
    wire [15:0] zero_word = result_bus[31:16] | result_bus[15:0];
    wire [7:0] zero_byte = zero_word[15:8] | zero_word[7:0];
    wire [3:0] zero_nibble = zero_byte[7:4] | zero_byte[3:0];
    assign zero = ~(|zero_nibble);

    // Flag Generation
    assign negative = result_bus[31];
    assign carry = (arith_res[32] & ~is_signed_arith);
    
    assign overflow = is_signed_arith & 
        ((aluc == ADD) ? 
            ((a[31] == b[31]) && (result_bus[31] != a[31])) :
            ((a[31] != b[31]) && (result_bus[31] != a[31])));

    // Output stage
    always @(*) begin
        r = result_bus;
        flag = is_compare ? comp_res[0] : 1'bz;
    end

endmodule