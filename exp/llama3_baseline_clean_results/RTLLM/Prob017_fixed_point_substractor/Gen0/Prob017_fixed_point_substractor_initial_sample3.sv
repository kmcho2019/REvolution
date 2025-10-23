module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Check if the signs of a and b are the same
    if ((a[N-1] == 1 && b[N-1] == 1) || (a[N-1] == 0 && b[N-1] == 0)) begin
        // Perform subtraction with same sign
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            // If a is negative and b is positive or vice versa, set the sign bit accordingly
            if (a[N-1] == 1) begin
                res[N-1] = 1'b1;
            end else begin
                res[N-1] = 1'b0;
            end
        end
    end else begin
        // Perform addition if signs are different
        res = a + ~b + 1'b1;
    end
    
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule