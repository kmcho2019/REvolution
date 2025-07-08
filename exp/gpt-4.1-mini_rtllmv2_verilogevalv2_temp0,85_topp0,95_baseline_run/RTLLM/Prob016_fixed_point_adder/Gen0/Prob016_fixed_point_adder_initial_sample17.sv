module fixed_point_adder #(
    parameter Q = 8,      // Number of fractional bits
    parameter N = 16      // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-2:0] abs_a;
    reg [N-2:0] abs_b;
    reg [N-1:0] sum;
    reg [N-1:0] diff;
    reg        sign_a;
    reg        sign_b;
    reg        sign_res;
    reg [N-2:0] abs_res;

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = a[N-2:0];
        abs_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum = {1'b0, abs_a} + {1'b0, abs_b};
            // Set sign bit same as operands
            sign_res = sign_a;
            // Assign result magnitude
            // sum might be one bit wider than N-1 bits, so truncate overflow bit if needed
            abs_res = sum[N-1:1];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_a >= abs_b) begin
                diff = {1'b0, abs_a} - {1'b0, abs_b};
                sign_res = sign_a;  // sign of the operand with larger magnitude
                abs_res = diff[N-2:0];
            end else begin
                diff = {1'b0, abs_b} - {1'b0, abs_a};
                sign_res = sign_b;
                abs_res = diff[N-2:0];
            end
        end

        // Compose the result: sign + magnitude
        c = {sign_res, abs_res};
    end

endmodule