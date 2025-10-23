module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

wire signed [N-1:0] a_signed, b_signed; // Signed versions of inputs for easier manipulation
reg [N-1:0] res; // Internal register for the result

// Convert inputs to signed numbers for easier arithmetic
assign a_signed = a[N-1] ? -({1'b0, a[N-1:0]}) : {1'b0, a[N-1:0]};
assign b_signed = b[N-1] ? -({1'b0, b[N-1:0]}) : {1'b0, b[N-1:0]};

// Perform addition, taking into account the fixed-point precision
always @(*) begin
    // Calculate the result of the addition
    res = a_signed + b_signed;
    
    // Ensure the result does not overflow
    if (res >= (1 << (N-1))) begin
        res = {1'b1, {N-1{1'b1}}}; // Maximum positive value
    end else if (res < -(1 << (N-1))) begin
        res = {N{1'b1}}; // Minimum negative value (two's complement)
    end
    
    // Adjust the result according to the fixed-point format
    // Ensure the sign bit is correctly set based on the result
    if (res[N-1]) begin
        c = {1'b1, {N-1{1'b0}}}; // Negative result, set sign bit
    end else begin
        c = res[N-1:0]; // Positive result, keep as is
    end
end

endmodule