module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Result sign determination
    wire res_sign;
    assign res_sign = (a_sign == b_sign) ? a_sign :  // Same sign: result has same sign
                     (a_sign ? !a_gt_b : a_gt_b);    // Different signs: depends on magnitude

    // Magnitude processing
    wire [N-2:0] res_mag;
    assign res_mag = (a_sign == b_sign) ? (a_gt_b ? a_mag - b_mag : b_mag - a_mag) :  // Same sign: subtract
                     (a_sign ? b_mag + a_mag : a_mag + b_mag);  // Different signs: add

    // Zero detection and result construction
    always @(*) begin
        if (mag_equal && (a_sign != b_sign)) begin  // Special case: a = -b
            c = {1'b0, {(N-1){1'b0}}};  // Force positive zero
        end else if (res_mag == {(N-1){1'b0}}) begin  // Magnitude zero
            c = {1'b0, {(N-1){1'b0}}};  // Force positive zero
        end else begin
            c = {res_sign, res_mag};  // Normal case
        end
    end

endmodule