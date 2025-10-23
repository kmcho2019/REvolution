module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg [N-1:0] res;

    // Combinational block for fixed-point addition
    always @* begin
        // Compute absolute values of a and b
        if (a[N-1] == 1'b1)
            abs_a = (~a) + 1'b1; // two's complement if negative
        else
            abs_a = a;

        if (b[N-1] == 1'b1)
            abs_b = (~b) + 1'b1;
        else
            abs_b = b;

        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;

            // Truncate to N bits (overflow discarded)
            res = sum_abs[N-1:0];

            // Set sign bit to the common sign
            res[N-1] = a[N-1];
        end else begin
            // Different sign: subtract smaller absolute value from larger absolute value
            if (abs_a >= abs_b) begin
                diff_abs = abs_a - abs_b;
                res = diff_abs[N-1:0];
                // Sign bit: if result non-zero, sign of 'a', else 0
                if (diff_abs == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = a[N-1];
            end else begin
                diff_abs = abs_b - abs_a;
                res = diff_abs[N-1:0];
                // Sign bit: if result non-zero, sign of 'b', else 0
                if (diff_abs == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = b[N-1];
            end
        end

        c = res;
    end

endmodule