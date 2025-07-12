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
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // For SLLV/SRLV/SRAV
    
    // Unified arithmetic unit
    wire do_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_res = do_arith ? 
                           (is_sub ? {1'b0, a} - {1'b0, b} : {1'b0, a} + {1'b0, b}) : 
                           33'b0;
    
    // Barrel shifter implementation
    wire do_shift = (aluc[5:3] == 3'b000);
    wire [31:0] shift_result = 
        do_shift ? 
            (aluc[1:0] == 2'b00) ? b << shift_amount :  // SLL/SLLV
            (aluc[1:0] == 2'b10) ? b >> shift_amount :  // SRL/SRLV
            $signed(b) >>> shift_amount :               // SRA/SRAV
        32'b0;

    // Comparison result (shared between SLT/SLTU)
    wire comparison = (aluc == SLT) ? (a_signed < b_signed) : (a < b);

    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_res[31:0];
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT, SLTU: r = {31'b0, comparison};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase

        // Flag output only for SLT/SLTU
        flag = (aluc == SLT || aluc == SLTU) ? comparison : 1'b0;
    end

    // Optimized flag assignments
    assign zero = ~|r;
    assign carry = do_arith ? arith_res[32] : 1'b0;
    assign negative = r[31];
    
    // Simplified overflow detection
    wire add_ovf = ~a[31] & ~b[31] & r[31];
    wire sub_ovf = ~a[31] & b[31] & r[31];
    assign overflow = (aluc == ADD) ? add_ovf :
                     (aluc == SUB) ? sub_ovf : 1'b0;

endmodule