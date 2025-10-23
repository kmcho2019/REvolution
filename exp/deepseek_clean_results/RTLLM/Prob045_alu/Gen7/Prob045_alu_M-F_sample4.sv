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
    wire arithmetic_op = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire shift_op = (aluc[5:4] == 2'b00);
    wire compare_op = (aluc == SLT || aluc == SLTU);
    
    // Arithmetic operations (computed conditionally)
    wire [32:0] arith_res = (aluc[0] ? {1'b0, a} + {1'b0, b} :  // ADD/ADDU
                            {1'b0, a} + {1'b0, ~b} + 33'b1);    // SUB/SUBU
    
    // Unified barrel shifter
    wire [31:0] shift_result;
    assign shift_result = (aluc[1:0] == 2'b00) ? b << shift_amount :  // SLL/SLLV
                         (aluc[1:0] == 2'b10) ? b >> shift_amount :  // SRL/SRLV
                         signed_b >>> shift_amount;                  // SRA/SRAV
    
    // Comparison results
    wire slt_res = signed_a < signed_b;
    wire sltu_res = a < b;
    
    // Operation result selection with combined flag output
    reg [31:0] result;
    reg flag_reg;
    always @(*) begin
        flag_reg = 1'b0;
        case (aluc)
            ADD, ADDU: begin result = arith_res[31:0]; end
            SUB, SUBU: begin result = arith_res[31:0]; end
            AND:       result = a & b;
            OR:        result = a | b;
            XOR:       result = a ^ b;
            NOR:       result = ~(a | b);
            SLT:       begin result = {31'b0, slt_res}; flag_reg = slt_res; end
            SLTU:      begin result = {31'b0, sltu_res}; flag_reg = sltu_res; end
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
    assign carry = arithmetic_op ? arith_res[32] : 1'b0;
    
    // Optimized overflow detection
    wire same_sign = (a[31] == b[31]);
    wire result_sign_diff = (result[31] != a[31]);
    assign overflow = (aluc == ADD) ? same_sign & result_sign_diff :
                    (aluc == SUB) ? ~same_sign & result_sign_diff : 1'b0;
    
    assign flag = flag_reg;

endmodule