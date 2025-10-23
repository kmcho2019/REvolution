module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Absolute values (magnitude without sign)
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    
    // Temporary results
    wire [N-1:0] sum, diff;
    wire diff_sign;
    
    // Case 1: Same signs (both positive or both negative)
    wire same_sign = (a_sign == b_sign);
    assign sum = {a_sign, a_mag + b_mag};
    
    // Case 2: Different signs
    wire a_larger = (a_mag > b_mag);
    assign diff = a_larger ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};
    assign diff_sign = a_larger ? a_sign : b_sign;
    
    // Final result selection
    assign c = same_sign ? sum : {diff_sign, diff[N-2:0]};
    
    // Overflow detection
    assign overflow = same_sign && (a_mag + b_mag > {1'b0, {(N-1){1'b1}}});

endmodule