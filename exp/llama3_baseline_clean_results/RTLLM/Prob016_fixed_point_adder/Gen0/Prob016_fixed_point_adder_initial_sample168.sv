module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a, 
    input   [N-1:0] b, 
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register for storing the result

// Calculate the absolute values of a and b
wire [N-1:0] abs_a = (a[N-1] == 1'b0) ? a : (~a + 1'b1);
wire [N-1:0] abs_b = (b[N-1] == 1'b0) ? b : (~b + 1'b1);

// Determine the result based on the signs of a and b
always @(a or b) begin
    if (a[N-1] == b[N-1]) begin // Same signs
        // Add the absolute values and set the sign bit accordingly
        res = (a[N-1] == 1'b0) ? (abs_a + abs_b) : -(~(abs_a + abs_b) + 1'b1);
    end else begin // Different signs
        // Determine the larger absolute value and perform subtraction
        if (abs_a >= abs_b) begin
            res = a[N-1] ? -(~(abs_a - abs_b) + 1'b1) : (abs_a - abs_b);
        end else begin
            res = b[N-1] ? -(~(abs_b - abs_a) + 1'b1) : (abs_b - abs_a);
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule