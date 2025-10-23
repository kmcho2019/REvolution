`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // Fixed-point inputs (two's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c      // Fixed-point output (two's complement)
);

    // Internal registers for sign and magnitude extraction
    reg sign_a, sign_b;
    reg [N-2:0] mag_a, mag_b;    // Magnitude widths (N-1 bits: excluding sign bit)

    reg sign_res;
    reg [N-2:0] mag_res;

    // Temporary result register (N bits) before output assign
    reg [N-1:0] res;

    // Function: two's complement magnitude extraction
    function [N-2:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val[N-2:0]) + 1'b1;
            else
                abs_val = val[N-2:0];
        end
    endfunction

    // Function: Add magnitudes with one extra bit to prevent overflow
    function [N-1:0] mag_add(input [N-2:0] x, input [N-2:0] y);
        reg [N-1:0] sum_full;
        begin
            sum_full = {1'b0, x} + {1'b0, y};
            mag_add = sum_full;
        end
    endfunction

    // Function: Subtract magnitudes, output magnitude and sign
    // Assumes inputs are positive magnitudes
    // Returns: {sign_res, magnitude}
    function [N-1:0] mag_sub(input [N-2:0] x, input [N-2:0] y);
        reg [N-2:0] diff;
        reg sign_s;
        begin
            if (x >= y) begin
                diff = x - y;
                sign_s = 1'b0; // positive
            end else begin
                diff = y - x;
                sign_s = 1'b1; // negative
            end
            mag_sub = {sign_s, diff};
        end
    endfunction

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Extract magnitudes
        mag_a = abs_val(a);
        mag_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: subtract magnitudes, result sign same as inputs if non-zero
            // mag_res and sign_res determined by magnitude subtraction
            {sign_res, mag_res} = mag_sub(mag_a, mag_b);

            // If signs same, result sign is sign_a XOR sign_res (mag_sub sign indicates magnitude comparison)
            // If a >= b (mag_sub sign_res=0), result sign = sign_a
            // If a < b (mag_sub sign_res=1), result sign = ~sign_a
            // Because subtracting b from a with same sign:
            // if mag_a >= mag_b => result sign = sign_a
            // else result sign = inverted sign (e.g., -a + b = b - a)
            if (sign_res == 1'b1) begin
                sign_res = ~sign_a;
            end else begin
                sign_res = sign_a;
            end
        end else begin
            // Different sign subtraction = addition of magnitudes
            // The result sign depends on magnitude comparison: bigger magnitude's sign
            // Compute magnitude sum
            reg [N-1:0] sum_mag;
            reg sign_greater;
            sum_mag = mag_add(mag_a, mag_b);
            // Determine which magnitude is greater for sign
            if (mag_a >= mag_b)
                sign_greater = sign_a;
            else
                sign_greater = sign_b;

            sign_res = sign_greater;
            mag_res = sum_mag[N-2:0]; // discard extra carry bit
        end

        // Construct result based on sign_res and mag_res
        if ((mag_res == {N-1{1'b0}})) begin
            // Zero result: force sign bit to zero
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            if (sign_res == 1'b0) begin
                // Positive result: magnitude directly assigned
                res = {1'b0, mag_res};
            end else begin
                // Negative result: convert magnitude to two's complement negative
                res = {1'b1, (~mag_res) + 1'b1};
            end
        end

        c = res;
    end

endmodule


// Testbench for verification

module tb_fixed_point_subtractor;
    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert real number to fixed-point two's complement signed representation
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            // Clamp to representable range to avoid overflow
            if (scaled > (2.0**(N-1)-1))
                real_to_fixed = (2**(N-1)) - 1;
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = -(2**(N-1));
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Convert fixed-point two's complement to real number
    function real fixed_to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
        begin
            sval = val;
            fixed_to_real = sval / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |        a        |        b        |        c        | Expected");
        $display("---------------------------------------------------------------------");

        // Test vectors
        a = real_to_fixed(1.5);      b = real_to_fixed(0.5);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        a = real_to_fixed(-2.25);    b = real_to_fixed(1.25);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        a = real_to_fixed(0.75);     b = real_to_fixed(-0.75);    #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        a = real_to_fixed(-1.0);     b = real_to_fixed(-1.0);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(0.0);      b = real_to_fixed(0.0);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = {1'b0, {(N-1){1'b1}}};  // max positive (0.999..)
        b = {1'b1, {(N-1){1'b0}}};  // max negative (-32768 or min)
        #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        a = real_to_fixed(-0.25);    b = real_to_fixed(0.5);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1);      b = real_to_fixed(0.1);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Edge case: a < b but same sign negative
        a = real_to_fixed(-3.0);     b = real_to_fixed(-4.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -3.0 - (-4.5));

        // Edge case: a > b but different signs
        a = real_to_fixed(2.0);      b = real_to_fixed(-1.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 2.0 - (-1.5));

        $finish;
    end
endmodule