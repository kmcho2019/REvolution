module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign bits of the input operands
reg sign_a;
reg sign_b;

assign sign_a = a[N-1];
assign sign_b = b[N-1];

// Perform addition if both operands have the same sign
always @(*) begin
    if (sign_a == sign_b) begin
        res = a + b;
        // Handle overflow by checking the MSB
        if (res[N-1] != sign_a) begin
            if (sign_a == 1'b0) begin
                // Positive overflow
                res = {1'b0, {N-1{1'b1}}};
            end else begin
                // Negative overflow
                res = {1'b1, {N-1{1'b0}}};
            end
        end
    end else begin
        // Perform subtraction if the operands have different signs
        if (a > b) begin
            res = a - b;
            // Sign bit remains positive if a > b
            if (res == 0) begin
                res = {1'b0, {N-1{1'b0}}};
            end
        end else if (b > a) begin
            res = b - a;
            // Sign bit remains positive if result is positive
            if (res == 0) begin
                res = {1'b0, {N-1{1'b0}}};
            end
        end
    end
end

assign c = res;

endmodule