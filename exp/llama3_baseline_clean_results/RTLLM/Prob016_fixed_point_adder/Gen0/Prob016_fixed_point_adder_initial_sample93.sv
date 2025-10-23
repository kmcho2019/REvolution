module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the sign of the inputs
    if (a[N-1] == b[N-1]) begin // Same signs
        // Add the absolute values and set the sign of the result
        res = (a[N-1] == 1'b0) ? (a + b) : -(~a + 1 + ~b + 1);
    end else begin // Different signs
        // Calculate the absolute values of a and b
        reg [N-1:0] abs_a;
        reg [N-1:0] abs_b;
        
        // Determine the absolute values
        abs_a = (a[N-1] == 1'b0) ? a : -(~a + 1);
        abs_b = (b[N-1] == 1'b0) ? b : -(~b + 1);
        
        // Subtract the smaller absolute value from the larger one and set the sign
        if (abs_a > abs_b) begin
            res = a[N-1] ? -(~a + 1 - (~b + 1)) : (a - b);
        end else begin
            res = b[N-1] ? -(~b + 1 - (~a + 1)) : (b - a);
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule