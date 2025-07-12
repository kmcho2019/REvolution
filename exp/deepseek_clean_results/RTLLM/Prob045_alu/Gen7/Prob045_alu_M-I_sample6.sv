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
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = aluc[3] ? a[4:0] : b[4:0];
    
    // Optimized arithmetic units
    wire [32:0] arith_res;
    wire arith_sel = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire [32:0] b_operand = is_add ? {1'b0, b} : {1'b0, ~b} + 33'b1;
    assign arith_res = {1'b0, a} + b_operand;
    
    // Unified barrel shifter
    wire [31:0] shift_result;
    wire [1:0] shift_op = aluc[1:0];
    assign shift_result = 
        (shift_op == 2'b00) ? (b << shift_amount) :
        (shift_op == 2'b10) ? (b >> shift_amount) :
        (signed_b >>> shift_amount);
    
    // Shared comparison logic
    wire cmp_res = (aluc == SLT) ? (signed_a < signed_b) : (a < b);
    
    // Operation result selection with operand isolation
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: result = arith_res[31:0];
            AND:       result = arith_sel ? 32'b0 : (a & b);
            OR:        result = arith_sel ? 32'b0 : (a | b);
            XOR:       result = arith_sel ? 32'b0 : (a ^ b);
            NOR:       result = arith_sel ? 32'b0 : (~(a | b));
            SLT, SLTU: result = {31'b0, cmp_res};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: result = shift_result;
            LUI:      result = {b[15:0], 16'b0};
            default:   result = 32'b0;
        endcase
    end
    
    // Optimized flag generation
    assign r = result;
    assign zero = ~(|result);
    assign negative = result[31];
    
    // Shared carry/overflow logic
    wire arith_carry = arith_res[32];
    wire add_overflow = ~aluc[0] & (a[31] == b[31]) & (result[31] != a[31]);
    wire sub_overflow = ~aluc[0] & (a[31] != b[31]) & (result[31] != a[31]);
    
    assign carry = arith_sel ? arith_carry : 1'b0;
    assign overflow = (aluc == ADD) ? add_overflow :
                     (aluc == SUB) ? sub_overflow : 1'b0;
    
    // Optimized flag output
    assign flag = (aluc == SLT || aluc == SLTU) ? cmp_res : 1'b0;

endmodule