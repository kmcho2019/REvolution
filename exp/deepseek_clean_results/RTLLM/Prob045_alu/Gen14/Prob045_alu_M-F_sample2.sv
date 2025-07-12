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

    // Operation detection
    wire op_add  = (aluc == ADD || aluc == ADDU);
    wire op_sub  = (aluc == SUB || aluc == SUBU);
    wire op_and  = (aluc == AND);
    wire op_or   = (aluc == OR);
    wire op_xor  = (aluc == XOR);
    wire op_nor  = (aluc == NOR);
    wire op_slt  = (aluc == SLT);
    wire op_sltu = (aluc == SLTU);
    wire op_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire op_lui  = (aluc == LUI);

    // Shared arithmetic unit
    wire [32:0] arith_result;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    assign arith_result = op_add ? {1'b0, a} + {1'b0, b} :
                         op_sub ? {1'b0, a} - {1'b0, b} :
                         33'b0;

    // Unified shifter
    wire [4:0] shift_amount = (aluc[3] || aluc == SLLV || aluc == SRLV || aluc == SRAV) ? 
                             a[4:0] : b[4:0];
    wire [31:0] shift_result;
    
    always @(*) begin
        case (aluc)
            SLL, SLLV: shift_result = b << shift_amount;
            SRL, SRLV: shift_result = b >> shift_amount;
            SRA, SRAV: shift_result = signed_b >>> shift_amount;
            default: shift_result = 32'b0;
        endcase
    end

    // Result selection
    reg [31:0] result;
    always @(*) begin
        case (1'b1)
            op_add, op_sub: result = arith_result[31:0];
            op_and: result = a & b;
            op_or:  result = a | b;
            op_xor: result = a ^ b;
            op_nor: result = ~(a | b);
            op_slt: result = (signed_a < signed_b) ? 32'b1 : 32'b0;
            op_sltu: result = (a < b) ? 32'b1 : 32'b0;
            op_shift: result = shift_result;
            op_lui: result = {b[15:0], 16'b0};
            default: result = 32'b0;
        endcase
    end

    // Flag generation
    assign r = result;
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = (op_add || op_sub) ? arith_result[32] : 1'b0;
    
    assign overflow = (aluc == ADD) ? ((a[31] == b[31]) && (result[31] != a[31])) :
                     (aluc == SUB) ? ((a[31] != b[31]) && (result[31] != a[31])) :
                     1'b0;
    
    assign flag = (op_slt || op_sltu) ? result[0] : 1'b0;

endmodule