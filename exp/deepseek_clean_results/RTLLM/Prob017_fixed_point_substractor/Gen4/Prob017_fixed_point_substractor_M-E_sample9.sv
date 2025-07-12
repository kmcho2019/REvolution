module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Sign-magnitude conversion
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire magnitudes_equal = (a_mag == b_mag);

    // Operation selection
    wire op_add = (a_sign ^ b_sign);  // Different signs = addition
    wire op_sub = ~(a_sign ^ b_sign); // Same signs = subtraction

    // Compute result magnitude
    wire [N-1:0] res_mag;
    assign res_mag = op_add ? (a_mag + b_mag) : 
                    (a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag));

    // Determine result sign
    reg res_sign;
    always @* begin
        if (magnitudes_equal && op_sub) begin
            res_sign = 1'b0;  // Force positive zero
        end
        else if (op_add) begin
            res_sign = a_sign; // Result takes sign of first operand
        end
        else begin
            res_sign = a_gt_b ? a_sign : b_sign;
        end
    end

    // Handle zero explicitly
    wire is_zero = (res_mag == 0);
    wire [N-1:0] res_signed = {res_sign & ~is_zero, res_mag[N-2:0]};

    // Overflow detection
    assign overflow = (res_mag[N-1] && !(a[N-1] && b[N-1]));

    // Final output assignment
    always @* begin
        c = res_signed;
    end

endmodule