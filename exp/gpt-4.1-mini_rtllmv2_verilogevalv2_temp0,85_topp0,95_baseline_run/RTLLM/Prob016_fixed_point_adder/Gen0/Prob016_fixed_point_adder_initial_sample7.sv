module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    // Internal signals for sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            reg [N:0] sum_abs; // one bit wider to detect overflow if needed
            sum_abs = abs_a + abs_b;
            // Assign result: sign same as inputs, magnitude sum_abs truncated to N-1 bits
            // Handle possible overflow: if sum_abs[N] is set, overflow occurred, truncate
            res = {sign_a, sum_abs[N-2:0]};
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a >= abs_b) begin
                reg [N-1:0] diff;
                diff = abs_a - abs_b;
                // Sign is sign of a (which has larger abs)
                if (diff == 0)
                    res = {1'b0, {N-1{1'b0}}}; // zero is positive zero
                else
                    res = {sign_a, diff[N-2:0]};
            end else begin
                reg [N-1:0] diff;
                diff = abs_b - abs_a;
                // Sign is sign of b (which has larger abs)
                if (diff == 0)
                    res = {1'b0, {N-1{1'b0}}}; // zero is positive zero
                else
                    res = {sign_b, diff[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule