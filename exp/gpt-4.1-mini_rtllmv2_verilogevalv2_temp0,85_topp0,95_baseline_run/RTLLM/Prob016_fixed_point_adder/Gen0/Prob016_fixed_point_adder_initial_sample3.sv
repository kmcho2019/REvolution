module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Signed representations of inputs
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Function to get absolute value of a signed number in two's complement
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1) // negative number
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Compare absolute values, returns 1 if abs(a) >= abs(b), else 0
    function abs_ge;
        input [N-1:0] a_val;
        input [N-1:0] b_val;
        begin
            abs_ge = (a_val >= b_val);
        end
    endfunction

    always @* begin
        // Extract signs
        wire sign_a = a[N-1];
        wire sign_b = b[N-1];

        // Compute absolute values
        reg [N-1:0] abs_a;
        reg [N-1:0] abs_b;
        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: absolute addition
            reg [N:0] sum_ext; // One extra bit for overflow
            sum_ext = abs_a + abs_b;
            // Assign result with sign bit preserved
            // Truncate to N bits - if overflow, wrap naturally
            res = sum_ext[N-1:0];
            res[N-1] = sign_a; // keep sign bit consistent
        end else begin
            // Different signs: absolute subtraction
            if (abs_ge(abs_a, abs_b)) begin
                // a is bigger or equal in absolute value
                reg [N-1:0] diff;
                diff = abs_a - abs_b;
                // sign bit is sign_a (0 if a positive)
                res = diff;
                res[N-1] = 1'b0; // result positive as per problem statement
                // However, problem states if a > b in abs, MSB set to 0 (positive)
            end else begin
                // b is bigger in absolute value
                reg [N-1:0] diff;
                diff = abs_b - abs_a;
                // If diff is zero, MSB = 0; else MSB = 1 (negative)
                if (diff == 0) begin
                    res = diff;
                    res[N-1] = 1'b0;
                end else begin
                    res = diff;
                    res[N-1] = 1'b1;
                end
            end
        end

        // Assign output
        c = res;
    end

endmodule