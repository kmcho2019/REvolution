module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine if the operands have the same sign
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // Check for overflow and adjust if necessary
        if (res[N] == 1'b1) begin
            // If overflow occurs, adjust the result to fit within N bits
            res = {1'b0, res[N-1:0]};
        end
    end else begin
        // Absolute value subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
        
        // Set the MSB of the result based on whether it's positive or negative
        if (res == 0) begin
            res = {N{1'b0}};
        end else if (res[N-1] == 1'b1) begin
            res = {1'b1, res[N-1:0]};
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule