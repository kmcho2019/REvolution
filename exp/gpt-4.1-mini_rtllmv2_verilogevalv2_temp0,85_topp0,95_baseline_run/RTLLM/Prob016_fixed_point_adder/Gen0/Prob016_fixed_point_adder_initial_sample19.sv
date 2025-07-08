module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    reg [N-2:0] abs_a;
    reg [N-2:0] abs_b;
    reg [N-2:0] abs_res;
    reg         sign_a;
    reg         sign_b;
    reg         sign_res;
    reg [N-1:0] res;

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Extract absolute values (magnitude without sign bit)
        abs_a = a[N-2:0];
        abs_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            abs_res = abs_a + abs_b;
            sign_res = sign_a;

            // Handle carry out of magnitude addition by saturating or truncating:
            // Since abs_res is N-1 bits wide, addition may overflow.
            // We keep only N-1 bits, overflow beyond that is lost, 
            // consistent with fixed width arithmetic.
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_a == abs_b) begin
                // Result is zero
                abs_res = {N-1{1'b0}};
                sign_res = 1'b0;
            end else if (abs_a > abs_b) begin
                abs_res = abs_a - abs_b;
                sign_res = sign_a;  // sign of the operand with larger magnitude
            end else begin
                abs_res = abs_b - abs_a;
                sign_res = sign_b;  // sign of the operand with larger magnitude
            end
        end

        // Compose result: sign bit + magnitude bits
        res = {sign_res, abs_res};
        c = res;
    end

endmodule