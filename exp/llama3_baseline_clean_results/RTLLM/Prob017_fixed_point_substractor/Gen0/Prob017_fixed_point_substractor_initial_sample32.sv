module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Extract the integer and fractional parts of the inputs
    reg [N-Q-1:0] int_a = a[N-2:Q];
    reg [N-Q-1:0] int_b = b[N-2:Q];
    reg [Q-1:0] frac_a = a[Q-1:0];
    reg [Q-1:0] frac_b = b[Q-1:0];

    // Perform the subtraction based on the signs of the inputs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        if (int_a > int_b || (int_a == int_b && frac_a >= frac_b)) begin
            // a is greater than or equal to b
            res = (sign_a ? 1'b1 : 1'b0) ? {1'b1, int_a - int_b, frac_a - frac_b} : {1'b0, int_a - int_b, frac_a - frac_b};
            if (res[N-1] != res[N-2]) begin
                // Handle overflow
                res = (res[N-1] ? {1'b1, {N-Q-1{1'b1}}, {Q{1'b1}}} : {1'b0, {N-Q-1{1'b0}}, {Q{1'b0}}});
            end
        end else begin
            // b is greater than a
            res = (sign_b ? 1'b1 : 1'b0) ? {1'b1, int_b - int_a, frac_b - frac_a} : {1'b0, int_b - int_a, frac_b - frac_a};
            if (res[N-1] != res[N-2]) begin
                // Handle overflow
                res = (res[N-1] ? {1'b1, {N-Q-1{1'b1}}, {Q{1'b1}}} : {1'b0, {N-Q-1{1'b0}}, {Q{1'b0}}});
            end
        end
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b1 && sign_b == 1'b0) begin
            // a is negative, b is positive
            res = {1'b0, int_a + int_b, frac_a + frac_b};
        end else begin
            // a is positive, b is negative
            res = {1'b0, int_a + int_b, frac_a + frac_b};
        end
        if (res[N-1] != res[N-2]) begin
            // Handle overflow
            res = (res[N-1] ? {1'b1, {N-Q-1{1'b1}}, {Q{1'b1}}} : {1'b0, {N-Q-1{1'b0}}, {Q{1'b0}}});
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = {N{1'b0}};
    end

    c = res;
end

endmodule