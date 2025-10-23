module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals
    wire same_sign;
    wire a_gt_b;
    wire signed [N-1:0] sum;
    wire signed [N-1:0] diff;
    wire overflow;
    wire signed [N-1:0] saturated;

    // Sign comparison
    assign same_sign = (a[N-1] == b[N-1]);
    assign a_gt_b = (a > b);

    // Arithmetic operations
    assign sum = a + b;
    assign diff = a_gt_b ? (a - b) : (b - a);

    // Overflow detection
    assign overflow = same_sign && (sum[N-1] != a[N-1]);

    // Saturation value
    assign saturated = a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};

    // Final output selection
    assign c = same_sign ? 
               (overflow ? saturated : sum) :
               (a_gt_b ? {a[N-1], diff[N-2:0]} : {b[N-1], diff[N-2:0]});

endmodule