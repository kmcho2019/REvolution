module fixed_point_subtractor #(
    parameter Q = 16,        // Fractional bits
    parameter N = 32,        // Total bits
    parameter ROUND = 0      // Rounding mode: 0-truncate, 1-round
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Internal signals
wire a_sign, b_sign;
wire [N-2:0] a_mag, b_mag;
wire sign_diff;
wire [N-1:0] mag_diff;
wire overflow, underflow;

// Extract signs and magnitudes
assign a_sign = a[N-1];
assign b_sign = b[N-1];
assign a_mag = a[N-2:0];
assign b_mag = b[N-2:0];

// Sign comparison
assign sign_diff = a_sign ^ b_sign;

// Magnitude comparison
wire a_gt_b = (a_mag > b_mag);

// Main subtraction logic
always @(*) begin
    if (sign_diff) begin
        // Different signs: effective addition
        {overflow, mag_diff[N-2:0]} = {1'b0, a_mag} + {1'b0, b_mag};
        mag_diff[N-1] = 1'b0; // Magnitude is always positive
        
        // Result sign follows larger operand or a if equal
        c[N-1] = a_gt_b ? a_sign : b_sign;
        c[N-2:0] = mag_diff[N-2:0];
    end
    else begin
        // Same signs: effective subtraction
        if (a_gt_b) begin
            c[N-2:0] = a_mag - b_mag;
            c[N-1] = a_sign;
        end
        else begin
            c[N-2:0] = b_mag - a_mag;
            c[N-1] = ~a_sign; // Flip sign if b > a
        end
    end

    // Handle zero explicitly
    if (c[N-2:0] == 0)
        c[N-1] = 0;

    // Overflow/underflow handling with saturation
    if (overflow) begin
        c[N-2:0] = {N-1{1'b1}}; // Max magnitude
        c[N-1] = a_gt_b ? a_sign : b_sign;
    end
    else if (underflow) begin
        c = 0; // Underflow to zero
    end

    // Rounding logic
    if (ROUND && (|c[Q-1:0])) begin
        c[N-2:Q] = c[N-2:Q] + 1;
        c[Q-1:0] = 0;
    end
end

// Overflow/underflow detection
assign overflow = sign_diff && mag_diff[N-1];
assign underflow = (~sign_diff) && (a_mag == b_mag);

endmodule