module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin // Both positive or both negative
        // Absolute value addition
        res = a + b;
    end else begin // One positive, one negative
        if (a[N-1] == 1) begin // a is negative
            if (b > (~a + 1)) begin // b is larger
                res = b - (~a + 1);
                res[N-1] = 0; // Set MSB to 0 (positive)
            end else begin // a is larger
                res = (~b + 1) - a;
                res[N-1] = 1; // Set MSB to 1 (negative)
            end
        end else begin // b is negative
            if (a > (~b + 1)) begin // a is larger
                res = a - (~b + 1);
                res[N-1] = 0; // Set MSB to 0 (positive)
            end else begin // b is larger
                res = (~a + 1) - b;
                res[N-1] = 1; // Set MSB to 1 (negative)
            end
        end
    end
    
    // Overflow handling
    if (res[N-1]!= a[N-1] && res[N-1]!= b[N-1]) begin
        if (a[N-1] == 0) begin // Both positive
            res = {1'b1, {N-1{1'b1}}}; // Set to max positive value
        end else begin
            res = {1'b0, {N-1{1'b0}}}; // Set to max negative value
        end
    end
    
    // Assign result to output
    c = res;
end

endmodule