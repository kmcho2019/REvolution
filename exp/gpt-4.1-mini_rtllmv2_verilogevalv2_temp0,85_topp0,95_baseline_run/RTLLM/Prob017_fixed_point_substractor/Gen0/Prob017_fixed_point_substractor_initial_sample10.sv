module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitude by masking off sign bit
    wire [N-2:0] mag_a = a[N-2:0];
    wire [N-2:0] mag_b = b[N-2:0];

    reg sign_res;
    reg [N-2:0] mag_res;

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = sign_a; // same sign, so result sign same as inputs
            end
        end else begin
            // Different sign: add magnitudes
            // Result sign depends on which magnitude is larger
            mag_res = mag_a + mag_b;
            // Determine sign based on which input has greater magnitude
            if (mag_a > mag_b)
                sign_res = sign_a;
            else if (mag_b > mag_a)
                sign_res = sign_b;
            else
                sign_res = 1'b0; // equal magnitudes means zero result
        end

        // Handle zero result explicitly: zero magnitude means sign = 0
        if (mag_res == 0)
            sign_res = 1'b0;

        // Compose result
        res = {sign_res, mag_res};
        c = res;
    end

endmodule