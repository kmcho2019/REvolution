module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Magnitude comparison (for subtraction cases)
    wire a_gt_b = (a_mag > b_mag);
    wire magnitudes_equal = (a_mag == b_mag);

    // Arithmetic operations
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};  // Extra bit for carry
    wire [N-1:0] diff = a_gt_b ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};

    // Result selection logic
    reg [N-1:0] result;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same signs: absolute addition with original sign
            result = {a_sign, sum[N-2:0]};
        end
        else begin
            // Different signs: absolute subtraction
            if (magnitudes_equal) begin
                result = 0;  // Equal magnitudes cancel out
            end
            else begin
                // Result takes sign of larger magnitude
                result = a_gt_b ? {a_sign, diff[N-2:0]} : {b_sign, diff[N-2:0]};
            end
        end
    end

    // Normalize result (handle overflow by saturation)
    wire overflow = (a_sign == b_sign) && (sum[N-1] != 1'b0);
    assign c = overflow ? 
               {a_sign, {(N-1){~a_sign}}} :  // Saturate to max/min
               result[N-1:0];                // Normal result

endmodule