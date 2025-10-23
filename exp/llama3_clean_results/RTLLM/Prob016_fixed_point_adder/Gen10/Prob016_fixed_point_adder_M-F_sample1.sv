module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    wire [N-1:0] abs_a;
    wire [N-1:0] abs_b;
    reg [N-1:0] res;
    reg sign_a, sign_b;

    // Calculate absolute values and detect signs
    assign abs_a = (a[N-1] == 1'b0)? a : (~a + 1);
    assign abs_b = (b[N-1] == 1'b0)? b : (~b + 1);
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    always @(*) begin
        // Determine operation based on signs
        if (sign_a == sign_b) begin
            // Addition
            res = abs_a + abs_b;
            // Apply sign to result
            if (sign_a == 1'b1) begin
                c = ~res + 1;
            end else begin
                c = res;
            end
        end else begin
            // Subtraction
            if (abs_a > abs_b) begin
                res = abs_a - abs_b;
                // Result is positive
                c = res;
            end else begin
                res = abs_b - abs_a;
                // Result is negative
                c = ~res + 1;
            end
        end

        // Check for overflow and saturate if necessary
        if (c[N-1]!= sign_a && sign_a == sign_b) begin
            c = (sign_a == 1'b1)? {N{1'b1}} : {N{1'b0}};
        end
    end

endmodule