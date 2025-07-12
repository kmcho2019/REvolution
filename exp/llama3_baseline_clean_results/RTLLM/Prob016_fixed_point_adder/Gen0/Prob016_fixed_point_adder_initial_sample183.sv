module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if the MSBs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Add the absolute values of a and b
        res = a + b;
        
        // Set the MSB of the result to match the MSBs of a and b
        if (a[N-1] == 1'b1) begin
            // Sign extend the result if a and b are negative
            res = {~(res[N-1]) + 1, res[N-1:0]};
        end
    end else begin
        // Determine the larger absolute value
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            if (a >= (~b + 1)) begin
                // a is greater than b
                res = a + (~b + 1);
            end else begin
                // b is greater than a
                res = (~a + 1) + b;
                // Set the MSB of the result to 1 (negative)
                res = {~(res[N-1]) + 1, res[N-1:0]};
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1) >= b) begin
                // a is greater than b
                res = (~a + 1) + (~b + 1);
                // Set the MSB of the result to 1 (negative)
                res = {~(res[N-1]) + 1, res[N-1:0]};
            end else begin
                // b is greater than a
                res = b + (~a + 1);
            end
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule