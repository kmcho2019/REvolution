module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    localparam INT_BITS = N - Q;  // Integer bits

    // Extract sign bits and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine operation and operand order
    wire do_add = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    
    // Prepare operands for arithmetic
    wire [N-1:0] op_a = do_add ? {1'b0, a_mag} : 
                       a_larger ? {1'b0, a_mag} : {1'b0, b_mag};
    wire [N-1:0] op_b = do_add ? {1'b0, b_mag} : 
                       a_larger ? {1'b0, b_mag} : {1'b0, a_mag};

    // Perform single arithmetic operation
    wire [N-1:0] arith_result = do_add ? (op_a + op_b) : (op_a - op_b);
    
    // Detect overflow (result exceeds N-1 bits)
    wire overflow = arith_result[N-1];
    
    // Determine result sign
    wire res_sign = do_add ? a_sign : 
                   (a_mag == b_mag) ? 1'b0 :  // Zero case
                   (a_larger ? a_sign : b_sign);
    
    // Form final result with overflow saturation
    assign c = overflow ? 
               {res_sign, {(N-1){~res_sign}}} :  // Saturate to max/min
               {res_sign, arith_result[N-2:0]};

endmodule