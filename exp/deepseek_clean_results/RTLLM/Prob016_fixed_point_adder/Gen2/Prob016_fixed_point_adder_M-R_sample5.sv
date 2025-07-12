module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] sum;
    wire signed [N-1:0] diff;
    wire overflow;
    wire same_sign;
    wire a_gt_b;
    wire [N-1:0] pos_sat = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] neg_sat = {1'b1, {(N-1){1'b0}}};

    // Control signals
    assign same_sign = (a[N-1] == b[N-1]);
    assign a_gt_b = (a > b);
    assign overflow = same_sign & ((a[N-1] != sum[N-1]));

    // Arithmetic operations
    assign sum = a + b;
    assign diff = a_gt_b ? (a - b) : (b - a);

    // Output selection
    assign c = same_sign ? 
               (overflow ? (a[N-1] ? neg_sat : pos_sat) : sum) :
               (a_gt_b ? {a[N-1], diff[N-2:0]} : {b[N-1], diff[N-2:0]});

endmodule