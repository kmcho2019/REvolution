module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(a, b) begin
    // Check if the MSBs of a and b are the same (both positive or both negative)
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // If the result is negative (overflow), adjust the MSB
        if (res[N-1] != a[N-1]) begin
            if (a[N-1] == 0) begin
                // Positive overflow, clip to maximum value
                res = {1'b0, {N-1{1'b1}}};
            end else begin
                // Negative overflow, clip to minimum value
                res = {1'b1, {N-1{1'b0}}};
            end
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > ( ~b + 1 )) begin
                // a is greater than b
                res = a - ( ~b + 1 );
            end else begin
                // b is greater than a
                res = ( ~b + 1 ) - a;
                // If the result is not zero, make it negative
                if (res != 0) begin
                    res = ~res + 1;
                end
            end
        end else begin
            // a is negative, b is positive
            if (( ~a + 1 ) > b) begin
                // a is greater than b (in absolute value)
                res = ( ~a + 1 ) - b;
                // If the result is not zero, make it negative
                if (res != 0) begin
                    res = ~res + 1;
                end
            end else begin
                // b is greater than a (in absolute value)
                res = b - ( ~a + 1 );
            end
        end
    end
end

assign c = res;

endmodule