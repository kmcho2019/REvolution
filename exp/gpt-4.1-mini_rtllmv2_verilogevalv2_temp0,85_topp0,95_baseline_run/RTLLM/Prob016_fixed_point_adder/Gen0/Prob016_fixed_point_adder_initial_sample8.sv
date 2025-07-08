module fixed_point_adder #(parameter Q=8, parameter N=16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg sign_a, sign_b;
    reg [N-2:0] mag_a, mag_b;
    reg [N-2:0] mag_res;
    reg sign_res;
    reg [N-1:0] res;

    // Function to get absolute value of input (two's complement)
    function [N-2:0] abs_mag;
        input [N-1:0] val;
        begin
            if(val[N-1] == 1'b1)
                abs_mag = (~val[N-2:0] + 1'b1);
            else
                abs_mag = val[N-2:0];
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a = abs_mag(a);
        mag_b = abs_mag(b);

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            mag_res = mag_a + mag_b;
            sign_res = sign_a;

            // Check for carry out of magnitude bits and saturate if needed
            // Since magnitude is N-1 bits, addition may overflow
            // Saturate to max magnitude if overflow
            if(mag_res > { {(N-1){1'b1}} })
                mag_res = { {(N-1){1'b1}} };
        end
        else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a > mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else if (mag_b > mag_a) begin
                mag_res = mag_b - mag_a;
                sign_res = sign_b;
            end else begin
                // Equal magnitude => result zero
                mag_res = { (N-1){1'b0} };
                sign_res = 1'b0; // positive zero
            end
        end

        // Reconstruct result from sign_res and mag_res
        if (mag_res == 0)
            res = {1'b0, mag_res}; // zero is positive
        else if (sign_res == 1'b0)
            res = {1'b0, mag_res};
        else
            res = {1'b1, (~mag_res + 1'b1)}; // two's complement negative

        c = res;
    end

endmodule