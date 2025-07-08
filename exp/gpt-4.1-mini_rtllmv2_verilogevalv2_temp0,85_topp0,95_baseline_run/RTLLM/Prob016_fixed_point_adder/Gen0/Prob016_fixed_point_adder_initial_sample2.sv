module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);
    reg [N-1:0] res;

    // Function to compute absolute value of fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    // Internal variables for absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values
            res = abs_a + abs_b;
            // If overflow beyond N bits, truncate (fixed width)
            // Set sign bit same as inputs
            res[N-1] = a[N-1];
        end else begin
            // Different sign: subtract smaller absolute value from larger absolute value
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                // Sign is sign of a
                // If result is zero, sign bit should be 0
                if (res == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = a[N-1];
            end else begin
                res = abs_b - abs_a;
                // Sign is sign of b
                if (res == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = b[N-1];
            end
        end
    end

    assign c = res;

endmodule