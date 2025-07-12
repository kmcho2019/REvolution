module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // N-bit register used to store the result

always @(a, b) begin
    // Check if both numbers have the same sign
    if (a[N-1] == b[N-1]) begin
        // Perform absolute value addition
        res = a + b;
        
        // Set the MSB of the result to match the MSBs of `a` and `b`
        if (a[N-1] == 1'b1) begin
            if (res >= (1 << N)) begin
                // Handle overflow for negative numbers
                res = -((1 << N) - res);
            end else begin
                res = -res;
            end
        end
    end else begin
        // Perform absolute value subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= -b) begin
                res = a + (~b + 1'b1);
            end else begin
                res = -((-b + 1'b1) - a);
            end
        end else begin // a is negative, b is positive
            if (-a >= b) begin
                res = -((-a + 1'b1) - b);
            end else begin
                res = -(b - (-a + 1'b1));
            end
        end
        
        // Set the MSB of the result according to the signs of `a` and `b` and the outcome of the operation
        if (res[N-1] == 1'b0 && (a[N-1] == 1'b1 || b[N-1] == 1'b1)) begin
            res = -res;
        end
    end

    // Truncate the result to the specified precision (Q fractional bits)
    c = res[N-1:0];
end

endmodule