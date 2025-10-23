module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Calculate the number of integer bits
localparam INT_BITS = N - Q;

// Internal wires for integer and fractional parts
wire signed [INT_BITS-1:0] int_a, int_b;
wire signed [Q-1:0] frac_a, frac_b;

// Internal wires for result
wire signed [INT_BITS-1:0] int_res;
wire signed [Q-1:0] frac_res;

// Extract integer and fractional parts
assign int_a = a >>> Q;
assign int_b = b >>> Q;
assign frac_a = a % (1 << Q);
assign frac_b = b % (1 << Q);

// Perform integer part subtraction
assign int_res = int_a - int_b;

// Perform fractional part subtraction
assign frac_res = frac_a - frac_b;

// Combine integer and fractional parts
always @(int_res or frac_res) begin
    if (int_res < 0 && frac_res < 0) begin
        // Handle negative result
        c = {int_res, frac_res};
    end else if (int_res >= 0 && frac_res >= 0) begin
        // Handle positive result
        c = {int_res, frac_res};
    end else begin
        // Handle mixed sign result
        if (abs(int_res) > abs(frac_res)) begin
            c = {int_res, frac_res};
        end else begin
            c = {int_res, frac_res};
        end
    end
end

endmodule