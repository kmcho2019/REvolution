module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    localparam MIN_N = Q + 1;
    initial begin
        if (N <= Q) $error("N must be greater than Q");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Absolute difference
    wire [N-2:0] abs_diff;
    assign abs_diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);

    // Full addition (including sign bits)
    wire [N-1:0] full_sum = a + b;

    // Result selection
    reg [N-1:0] result;
    always @(*) begin
        case ({a_sign, b_sign})
            2'b00, 2'b11: begin // Same signs: simple addition
                result = full_sum;
            end
            2'b01: begin // a positive, b negative
                if (a_gt_b)      result = {1'b0, abs_diff};
                else if (a_eq_b) result = 0;
                else             result = {1'b1, abs_diff};
            end
            2'b10: begin // a negative, b positive
                if (a_gt_b)      result = {1'b1, abs_diff};
                else if (a_eq_b) result = 0;
                else             result = {1'b0, abs_diff};
            end
            default: result = 0;
        endcase
    end

    assign c = result;

endmodule