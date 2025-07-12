module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of fixed-point number (N bits two's complement)
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1]) // negative
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Compare magnitudes: returns 1 if a_mag >= b_mag else 0
    function a_ge_b(input [N-1:0] a_mag, input [N-1:0] b_mag);
        begin
            a_ge_b = (a_mag >= b_mag);
        end
    endfunction

    // Intermediate wires for absolute values
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Intermediate wire for sum of magnitudes
    wire [N-1:0] sum_mag = a_abs + b_abs;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a - b
            res = a - b;
        end else begin
            // Different sign subtraction = addition of absolute values with sign logic
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                // sign positive if |a| >= |b| else negative
                if (a_ge_b(a_abs, b_abs))
                    res = sum_mag;       // positive sign
                else
                    res = (~sum_mag) + 1'b1; // negative sign
            end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                // a negative, b positive
                // sign negative if |a| >= |b| else positive
                if (a_ge_b(a_abs, b_abs))
                    res = (~sum_mag) + 1'b1; // negative sign
                else
                    res = sum_mag;       // positive sign
            end else begin
                // Should never happen
                res = {N{1'b0}};
            end
        end

        // If result is zero, explicitly clear sign bit
        if (res == {N{1'b0}}) begin
            res[N-1] = 1'b0;
        end
    end

    // Assign output
    assign c = res;

endmodule