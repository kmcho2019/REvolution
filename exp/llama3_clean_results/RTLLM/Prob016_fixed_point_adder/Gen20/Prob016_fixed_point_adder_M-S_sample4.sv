module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Internal register to store the result
    reg signed [N-1:0] res;

    // Calculate the sum of a and b
    always @(a, b) begin
        res = a + b;

        // Overflow handling
        if (res > { {N-1{1'b1}}, {1'b0} }) begin
            res = { {N-1{1'b1}}, {1'b0} };
        end else if (res < { {N-1{1'b0}}, {1'b1} }) begin
            res = { {N-1{1'b0}}, {1'b1} };
        end
    end

    // Assign the result to the output
    assign c = res;

endmodule