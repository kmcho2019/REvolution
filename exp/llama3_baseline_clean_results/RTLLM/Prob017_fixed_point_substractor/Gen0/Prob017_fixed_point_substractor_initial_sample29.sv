module fixed_point_subtractor #(
    parameter Q = 16,  // number of fractional bits
    parameter N = 32  // total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a;
    reg sign_b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // Remove the sign bit
        reg [N-2:0] abs_a;
        reg [N-2:0] abs_b;
        assign abs_a = {1'b0, a[N-2:0]};
        assign abs_b = {1'b0, b[N-2:0]};

        // Compare the absolute values
        if (abs_a > abs_b) begin
            res = abs_a - abs_b;
        end else begin
            res = (abs_b - abs_a);
            // Set the sign bit
            res[N-1] = 1'b1;
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0 for zero result
    end

    // Assign the result to the output
    c = res;
end

endmodule