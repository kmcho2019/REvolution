module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs of a and b are the same
        res = a + b;             // Absolute value addition
    end else begin
        if (a[N-1] == 0) begin  // a is positive
            if (a >= -b) begin   // a is greater than or equal to b
                res = a + b;     // a - b, but actually a + (-b)
            end else begin
                res = b + a;     // b - a, but actually -b + a
            end
        end else begin           // a is negative
            if (-a >= b) begin   // -a is greater than or equal to b
                res = a + b;     // a - b, but actually -a + (-b)
            end else begin
                res = b + a;     // b - a, but actually b + (-a)
            end
        end
    end

    // Ensure the result fits within the N-bit range
    if (res[N-1] == 1'b1 && res[N-2] == 1'b1) begin
        res = {1'b1, {N-1{1'b1}}};  // Saturate to max negative value
    end else if (res[N-1] == 1'b0 && res[N-2] == 1'b1) begin
        res = {1'b0, {N-1{1'b1}}};  // Saturate to max positive value
    end
end

assign c = res;

endmodule