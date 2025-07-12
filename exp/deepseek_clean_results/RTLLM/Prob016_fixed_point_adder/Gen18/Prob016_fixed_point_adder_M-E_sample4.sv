module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Shared arithmetic unit
    wire [N-1:0] arith_result;
    wire carry_out;
    wire op_sel = (a_sign ^ b_sign);  // 0 for add, 1 for subtract
    
    // Magnitude comparison (priority encoder style)
    wire a_larger = (a_mag > b_mag);
    wire swap_operands = (op_sel & ~a_larger);
    
    // Operand selection for shared arithmetic unit
    wire [N-2:0] op_a = swap_operands ? b_mag : a_mag;
    wire [N-2:0] op_b = swap_operands ? a_mag : b_mag;
    
    // Shared adder/subtractor
    assign {carry_out, arith_result[N-2:0]} = 
        op_sel ? (op_a - op_b) : (op_a + op_b);
    
    // Result sign determination
    wire res_sign = 
        (a_sign & b_sign) ? 1'b1 :                     // Both negative
        (op_sel & (a_larger ? a_sign : b_sign)) :       // Subtraction case
        1'b0;                                           // Default positive
    
    // Overflow detection and saturation
    wire overflow = ~op_sel & carry_out;
    wire [N-1:0] saturated = {res_sign, {(N-1){~res_sign}}};
    
    // Result formation
    assign arith_result[N-1] = res_sign;
    assign c = overflow ? saturated : arith_result;

endmodule