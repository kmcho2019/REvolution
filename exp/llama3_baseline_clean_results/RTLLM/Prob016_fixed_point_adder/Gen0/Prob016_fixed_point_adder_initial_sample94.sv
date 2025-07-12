module fixed_point_adder #(
    parameter N = 16,  // Total number of bits
    parameter Q = 8    // Number of fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Check if both inputs have the same sign
    if (a[N-1] == b[N-1]) begin
        // Perform absolute value addition
        res = a + b;
        
        // Ensure the sign of the result matches the inputs
        if (a[N-1] == 1'b1) begin  // Both are negative
            if (res < {N{1'b0}}) begin  // Result underflows
                res = {N{1'b1}};
            end else if (res[N-1] == 1'b0) begin  // Result is actually negative but was represented as positive due to overflow
                res = -res;
            end
        end
    end else begin
        // Determine which input has a larger absolute value
        if (a >= b) begin
            // Perform absolute value subtraction
            res = a - b;
            
            // Ensure the sign of the result is correct
            if (res < {N{1'b0}}) begin  // Result is negative
                res = -res;
            end
        end else begin
            // Perform absolute value subtraction in reverse order
            res = b - a;
            
            // Ensure the sign of the result is correct
            if (res < {N{1'b0}}) begin  // Result is negative
                res = -res;
            end
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule