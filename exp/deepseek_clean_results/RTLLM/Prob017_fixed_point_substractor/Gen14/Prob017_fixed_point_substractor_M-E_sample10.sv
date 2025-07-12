module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign, b_sign;
    wire [N-2:0] a_mag, b_mag;
    wire [N-1:0] mag_diff, mag_sum;
    wire a_gt_b, a_eq_b;
    wire res_sign;
    wire [N-1:0] res_mag;

    // Sign and magnitude decomposition
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag = a[N-2:0];
    assign b_mag = b[N-2:0];

    // Magnitude comparison
    assign a_gt_b = (a_mag > b_mag);
    assign a_eq_b = (a_mag == b_mag);

    // Magnitude operations
    assign mag_diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    assign mag_sum = a_mag + b_mag;

    // Result sign determination
    assign res_sign = (a_sign == b_sign) ? 
                     (a_sign ^ (b_mag > a_mag)) :  // Same sign case
                     (a_sign ? !a_gt_b : a_gt_b);  // Different signs

    // Magnitude selection
    assign res_mag = (a_sign == b_sign) ? mag_diff : mag_sum;

    // Zero detection and final result assembly
    always @(*) begin
        if (a_eq_b && (a_sign != b_sign)) begin
            c = {1'b0, {N-1{1'b0}}};  // Explicit zero
        end else begin
            c = {res_sign, res_mag};
        end
    end

endmodule