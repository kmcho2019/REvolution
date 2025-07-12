module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N-1:0] res;
    reg sign;

    always @(*) begin
        // Detect sign bits
        if (a[N-1] == b[N-1]) begin
            sign = a[N-1];
        end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            sign = 1'b0;
        end else begin
            sign = 1'b1;
        end

        // Calculate absolute values
        abs_a = (a[N-1] == 1'b1) ? (~a + 1) : a;
        abs_b = (b[N-1] == 1'b1) ? (~b + 1) : b;

        // Perform addition or subtraction
        if (a[N-1] == b[N-1]) begin
            res = abs_a + abs_b;
        end else if (abs_a > abs_b) begin
            res = abs_a - abs_b;
        end else begin
            res = abs_b - abs_a;
        end

        // Apply sign to result
        if (sign == 1'b1) begin
            c = ~res + 1;
        end else begin
            c = res;
        end

        // Check for overflow and saturate if necessary
        if (c[N-1] != sign) begin
            c = (sign == 1'b1) ? {N{1'b1}} : {N{1'b0}};
        end
    end

endmodule