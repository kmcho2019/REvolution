module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc[2] ? a[4:0] : b[4:0]); // Fixed missing parenthesis
    
    // Unified arithmetic unit
    wire add_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_res = add_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
    
    // Precompute comparisons
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    
    // Status flags
    assign zero = ~|r;  // Reduction NOR for zero detection
    assign carry = arith_res[32] & (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    assign negative = r[31];
    assign overflow = (aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
                     (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31]); // Fixed parentheses
    assign flag = (aluc == SLT) ? slt_res : 
                 (aluc == SLTU) ? sltu_res : 1'b0;

    // Combined operation block
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_res[31:0];
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = {31'b0, slt_res};
            SLTU: r = {31'b0, sltu_res};
            SLL:  r = b << shift_amount;
            SRL:  r = b >> shift_amount;
            SRA:  r = $signed(b) >>> shift_amount;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

endmodule