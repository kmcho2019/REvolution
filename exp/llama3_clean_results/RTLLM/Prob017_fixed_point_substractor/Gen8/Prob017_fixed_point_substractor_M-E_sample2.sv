module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Separate integer and fractional parts
wire signed [N-Q-1:0] a_int = a >> Q;
wire signed [Q-1:0] a_frac = a[N-Q-1:0];
wire signed [N-Q-1:0] b_int = b >> Q;
wire signed [Q-1:0] b_frac = b[N-Q-1:0];

// Perform integer part subtraction
wire signed [N-Q:0] int_result = a_int - b_int;

// Perform fractional part subtraction
wire signed [Q:0] frac_result = {1'b0, a_frac} - {1'b0, b_frac};

// Combine results, handling borrow/carry
reg signed [N:0] combined_result;
assign combined_result = {int_result, frac_result[Q-1:0]};

// Handle overflow and assign final result
always @(a or b) begin
    if (combined_result[N] == 1'b1) begin
        // Overflow, handle according to specific requirements (e.g., saturation)
        c = {1'b1, {N-1{1'b1}}}; // Example: Saturate to maximum negative value
    end else begin
        c = combined_result[N-1:0];
    end
end

endmodule