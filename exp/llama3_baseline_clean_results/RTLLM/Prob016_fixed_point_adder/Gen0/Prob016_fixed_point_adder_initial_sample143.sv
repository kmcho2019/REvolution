module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine signs of a and b
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Calculate absolute values
    reg [N-1:0] a_abs = (a_sign) ? (~a + 1) : a;
    reg [N-1:0] b_abs = (b_sign) ? (~b + 1) : b;

    // Check if signs are the same
    if (a_sign == b_sign) begin
        // Add absolute values
        res = a_abs + b_abs;
        // Set sign bit of result
        if (a_sign) begin
            // If overflow, set result to max negative value
            if (res[N-1] == 0) begin
                res = {1, {N-1{1'b1}}};
            end
        end
    end else begin
        // Subtract absolute values
        if (a_abs > b_abs) begin
            res = a_abs - b_abs;
        end else begin
            res = b_abs - a_abs;
            // Set sign bit of result
            res[N-1] = 1'b1;
            // If result is zero, set sign bit to zero
            if (res == {N{1'b0}}) begin
                res[N-1] = 1'b0;
            end
        end
    end
end

assign c = res;

endmodule