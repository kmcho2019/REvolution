module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Validate parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Sign comparison
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_larger = (a_mag > b_mag);

    // Result sign determination
    wire result_sign = signs_equal ? a_sign : 
                     (a_larger ? a_sign : b_sign);

    // Shared arithmetic unit
    wire [N-1:0] arith_result;
    wire carry_out;
    
    assign {carry_out, arith_result} = signs_equal ? 
                                      {1'b0, a_mag} + {1'b0, b_mag} :
                                      a_larger ? 
                                      {1'b0, a_mag} - {1'b0, b_mag} :
                                      {1'b0, b_mag} - {1'b0, a_mag};

    // Overflow occurs only when adding same signs and carry out is set
    wire overflow = signs_equal & carry_out;

    // Saturation values (fixed syntax)
    wire [N-1:0] max_positive = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_negative = {1'b1, {(N-1){1'b0}}};

    // Final result assembly
    assign c = overflow ? (result_sign ? max_negative : max_positive) :
               {result_sign, arith_result[N-2:0]};

endmodule