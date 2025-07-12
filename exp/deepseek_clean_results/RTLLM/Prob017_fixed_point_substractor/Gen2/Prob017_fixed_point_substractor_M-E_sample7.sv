module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Extract signs and magnitudes
wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-2:0] a_mag = a[N-2:0];
wire [N-2:0] b_mag = b[N-2:0];

// Magnitude comparison
wire a_gt_b = (a_mag > b_mag);
wire a_eq_b = (a_mag == b_mag);

// Result sign calculation
wire res_sign;
assign res_sign = (a_sign ^ b_sign) ? 
                 (a_sign ? ~a_gt_b : a_gt_b) : 
                 a_sign;

// Magnitude calculation
wire [N-2:0] res_mag;
assign res_mag = (a_sign == b_sign) ? 
                (a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag)) :
                (a_mag + b_mag);

// Final result assembly with zero detection
always @(*) begin
    if (a_eq_b && (a_sign != b_sign)) begin
        // Explicit zero case
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = {res_sign, res_mag};
    end
end

endmodule