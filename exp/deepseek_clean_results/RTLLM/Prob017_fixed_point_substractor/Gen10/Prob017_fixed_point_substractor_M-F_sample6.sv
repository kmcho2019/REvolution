module fixed_point_subtractor #(
    parameter N = 32,  // Total number of bits
    parameter Q = 16   // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    localparam M = N-1;  // Magnitude bits

    // Sign extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude calculation with conditional inversion
    wire [M-1:0] a_mag = a_sign ? (~a[M-1:0] + 1'b1) : a[M-1:0];
    wire [M-1:0] b_mag = b_sign ? (~b[M-1:0] + 1'b1) : b[M-1:0];

    // Single subtractor implementation
    wire [M-1:0] raw_diff = a_mag - b_mag;
    wire diff_sign = raw_diff[M-1];  // MSB indicates borrow

    // Comparison flags
    wire a_gt_b = ~diff_sign && (|raw_diff);  // No borrow and not zero
    wire a_eq_b = (a_mag == b_mag);
    wire a_lt_b = diff_sign;

    // Sign determination
    reg result_sign;
    always @* begin
        if (a_eq_b) begin
            result_sign = 1'b0;  // Zero case
        end
        else if (a_sign == b_sign) begin
            result_sign = a_sign ^ a_lt_b;  // Same sign: sign depends on magnitude
        end
        else begin
            result_sign = a_sign;  // Different signs: sign follows first operand
        end
    end

    // Result assembly
    wire [M-1:0] result_mag = a_gt_b ? raw_diff : 
                            a_lt_b ? (~raw_diff + 1'b1) : 
                            {M{1'b0}};
    assign c = a_eq_b ? {1'b0, {M{1'b0}}} : {result_sign, result_mag};

endmodule