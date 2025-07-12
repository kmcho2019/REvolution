module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Validate parameters at compile time
    initial begin
        if (Q >= N) begin
            $error("Invalid parameters: Q (%0d) must be less than N (%0d)", Q, N);
        end
    end

    // Sign bits and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Absolute difference
    wire [N-2:0] mag_diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);

    // Shared adder
    wire [N-1:0] mag_sum = {1'b0, a_mag} + {1'b0, b_mag};

    // Result computation
    reg [N-1:0] res;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign addition
            if (mag_sum[N-1]) begin
                // Overflow occurred - saturate
                res = {a_sign, {(N-1){~a_sign}}};
            end else begin
                res = {a_sign, mag_sum[N-2:0]};
            end
        end
        else begin
            // Different signs - subtraction
            if (mag_equal) begin
                res = {N{1'b0}}; // Zero result
            end else begin
                res = {(a_gt_b ? a_sign : b_sign), mag_diff};
            end
        end
    end

    assign c = res;

endmodule