module fixed_point_adder #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed registers
    reg signed [N-1:0] signed_a;
    reg signed [N-1:0] signed_b;
    reg signed [N-1:0] res;

    // Internal unsigned registers for absolute values
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;

    always @* begin
        // Cast inputs to signed
        signed_a = a;
        signed_b = b;

        // Compute absolute values inline (synthesis friendly)
        abs_a = signed_a[N-1] ? (~signed_a + 1'b1) : signed_a;
        abs_b = signed_b[N-1] ? (~signed_b + 1'b1) : signed_b;

        if (signed_a[N-1] == signed_b[N-1]) begin
            // Same sign: add directly
            res = signed_a + signed_b;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                // Set sign of result to sign of a
                res = signed_a[N-1] ? -res : res;
            end else begin
                res = abs_b - abs_a;
                // Set sign of result to sign of b
                res = signed_b[N-1] ? -res : res;
            end
        end

        // Assign result to output
        c = res;
    end

endmodule