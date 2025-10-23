module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg signed [N-1:0] signed_a, signed_b;
    reg signed [N-1:0] res;

    // Function to get absolute value of signed N-bit number
    function [N-1:0] abs_val;
        input signed [N-1:0] val;
        begin
            abs_val = (val < 0) ? -val : val;
        end
    endfunction

    always @* begin
        signed_a = a;
        signed_b = b;

        if (signed_a[N-1] == signed_b[N-1]) begin
            // Same sign: add directly
            res = signed_a + signed_b;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_val(signed_a) >= abs_val(signed_b)) begin
                res = abs_val(signed_a) - abs_val(signed_b);
                res = (signed_a[N-1]) ? -res : res;
            end else begin
                res = abs_val(signed_b) - abs_val(signed_a);
                res = (signed_b[N-1]) ? -res : res;
            end
        end
        c = res;
    end

endmodule