module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Parallel computation paths
    wire [N-1:0] sum_path = {a_sign, a_mag} + {b_sign, b_mag};
    wire [N-2:0] diff_path = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = (a_mag > b_mag) ? a_sign : b_sign;

    // Zero detection logic
    wire is_zero = (a_mag == b_mag) && (a_sign != b_sign);

    // Result selection
    reg [N-1:0] result;
    always @(*) begin
        case ({a_sign, b_sign})
            2'b00, 2'b11: result = sum_path;      // Same signs: use sum
            2'b01, 2'b10: begin                   // Different signs
                if (is_zero) result = 0;
                else result = {diff_sign, diff_path};
            end
            default: result = 0;
        endcase
    end

    // Overflow detection and handling (saturate to max/min)
    wire overflow = (a_sign == b_sign) && (sum_path[N-1] != a_sign);
    assign c = overflow ? {a_sign, {N-1{~a_sign}}} : result;

endmodule