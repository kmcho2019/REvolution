module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check the most significant bits (MSBs) of inputs a and b
    if (a[N-1] == b[N-1]) begin
        // If MSBs are the same, perform absolute value addition
        res = a + b;
        // Set the MSB of the result to match the MSBs of a and b
        if (a[N-1] == 1'b1) begin
            if (res[N-1] == 1'b0) begin
                // Handle overflow by extending the sign bit
                res = {1'b1, {N-1{1'b1}}};
            end
        end else begin
            if (res[N-1] == 1'b1) begin
                // Handle underflow by truncating the result
                res = {N-1{1'b0}};
            end
        end
    end else begin
        // If MSBs are different, perform absolute value subtraction
        if (a[N-1] == 1'b1) begin
            // a is negative, convert to positive
            res = (~a + 1'b1) - b;
        end else begin
            // b is negative, convert to positive
            res = a - (~b + 1'b1);
        end
        // Set the MSB of the result accordingly
        if (res[N-1] == 1'b1) begin
            // Result is negative
            res = {1'b1, {N-1{1'b1}}};
        end
    end
    // Assign the result to output c
    c = res;
end

endmodule