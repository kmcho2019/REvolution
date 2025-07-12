module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Function to get absolute value of N-bit signed number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1) // negative number
                abs_val = (~val) + 1'b1; // two's complement
            else
                abs_val = val;
        end
    endfunction

    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg [N-1:0] larger, smaller;

    always @* begin
        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;

            // Truncate sum_abs to N bits (overflow discarded)
            res = sum_abs[N-1:0];

            // Set sign bit to input sign
            res[N-1] = a[N-1];
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a >= abs_b) begin
                larger  = abs_a;
                smaller = abs_b;
                diff_abs = larger - smaller;

                res = diff_abs[N-1:0];

                // Sign is sign of 'a' if difference != 0, else zero
                if (diff_abs == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = a[N-1];
            end else begin
                larger  = abs_b;
                smaller = abs_a;
                diff_abs = larger - smaller;

                res = diff_abs[N-1:0];

                // Sign is sign of 'b' if difference != 0, else zero
                if (diff_abs == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = b[N-1];
            end
        end

        c = res;
    end

endmodule