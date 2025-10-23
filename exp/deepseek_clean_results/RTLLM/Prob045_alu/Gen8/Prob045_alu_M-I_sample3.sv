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
    wire [4:0] shift_amount = (aluc[3:1] == 3'b000) ? a[4:0] : b[4:0];
    
    // Operation detection
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire is_arith = is_add | is_sub;
    wire is_shift = (aluc[5:4] == 2'b00);
    wire is_compare = (aluc == SLT || aluc == SLTU);
    
    // Carry-select adder implementation
    wire [15:0] sum_low, sum_high0, sum_high1;
    wire cout_low, cout_high0, cout_high1;
    
    // Lower 16 bits
    assign {cout_low, sum_low} = is_add ? (a[15:0] + b[15:0]) : 
                                is_sub ? (a[15:0] + ~b[15:0] + 1'b1) : 
                                17'b0;
    
    // Upper 16 bits with carry=0
    assign {cout_high0, sum_high0} = is_add ? (a[31:16] + b[31:16]) : 
                                    is_sub ? (a[31:16] + ~b[31:16]) : 
                                    17'b0;
    
    // Upper 16 bits with carry=1
    assign {cout_high1, sum_high1} = is_add ? (a[31:16] + b[31:16] + 1'b1) : 
                                    is_sub ? (a[31:16] + ~b[31:16] + 1'b1) : 
                                    17'b0;
    
    // Final arithmetic result
    wire [31:0] arith_result = {cout_low ? sum_high1 : sum_high0, sum_low};
    wire arith_carry = cout_low ? cout_high1 : cout_high0;
    
    // Logarithmic barrel shifter
    wire [31:0] shift_stage1 = shift_amount[0] ? (aluc[0] ? {b[30:0], 1'b0} : 
                                                aluc[1] ? {1'b0, b[31:1]} : 
                                                {b[31], b[31:1]}) : b;
    
    wire [31:0] shift_stage2 = shift_amount[1] ? (aluc[0] ? {shift_stage1[29:0], 2'b0} : 
                                                aluc[1] ? {2'b0, shift_stage1[31:2]} : 
                                                {{2{shift_stage1[31]}}, shift_stage1[31:2]}) : shift_stage1;
    
    wire [31:0] shift_stage4 = shift_amount[2] ? (aluc[0] ? {shift_stage2[27:0], 4'b0} : 
                                                aluc[1] ? {4'b0, shift_stage2[31:4]} : 
                                                {{4{shift_stage2[31]}}, shift_stage2[31:4]}) : shift_stage2;
    
    wire [31:0] shift_stage8 = shift_amount[3] ? (aluc[0] ? {shift_stage4[23:0], 8'b0} : 
                                                aluc[1] ? {8'b0, shift_stage4[31:8]} : 
                                                {{8{shift_stage4[31]}}, shift_stage4[31:8]}) : shift_stage4;
    
    wire [31:0] shift_result = shift_amount[4] ? (aluc[0] ? {shift_stage8[15:0], 16'b0} : 
                                               aluc[1] ? {16'b0, shift_stage8[31:16]} : 
                                               {{16{shift_stage8[31]}}, shift_stage8[31:16]}) : shift_stage8;
    
    // Shared comparison logic
    wire signed_less = signed_a < signed_b;
    wire unsigned_less = a < b;
    wire same_sign = (a[31] == b[31]);
    wire result_sign_diff = (arith_result[31] != a[31]);
    
    // Operation result selection
    reg [31:0] result;
    reg flag_reg;
    always @(*) begin
        flag_reg = 1'b0;
        case (aluc)
            ADD, ADDU, SUB, SUBU: result = arith_result;
            AND:       result = a & b;
            OR:        result = a | b;
            XOR:       result = a ^ b;
            NOR:       result = ~(a | b);
            SLT:       begin result = {31'b0, signed_less}; flag_reg = signed_less; end
            SLTU:      begin result = {31'b0, unsigned_less}; flag_reg = unsigned_less; end
            SLL, SLLV: result = shift_result;
            SRL, SRLV: result = shift_result;
            SRA, SRAV: result = shift_result;
            LUI:       result = {b[15:0], 16'b0};
            default:   result = 32'b0;
        endcase
    end
    
    // Output assignments
    assign r = result;
    assign zero = ~|result;
    assign negative = result[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = (aluc == ADD) ? same_sign & result_sign_diff :
                    (aluc == SUB) ? ~same_sign & result_sign_diff : 1'b0;
    assign flag = flag_reg;

endmodule