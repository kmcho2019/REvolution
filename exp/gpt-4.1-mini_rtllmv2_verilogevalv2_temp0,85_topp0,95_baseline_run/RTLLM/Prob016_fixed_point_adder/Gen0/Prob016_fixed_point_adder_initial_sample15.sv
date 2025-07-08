module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    // Function to get absolute value of fixed-point two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val;
            else
                abs_val = (~val + 1'b1);
        end
    endfunction

    // Compare absolute values function: returns 1 if abs(a) > abs(b), else 0
    function abs_greater;
        input [N-1:0] a_in;
        input [N-1:0] b_in;
        reg [N-1:0] abs_a, abs_b;
        begin
            abs_a = abs_val(a_in);
            abs_b = abs_val(b_in);
            abs_greater = (abs_a > abs_b);
        end
    endfunction

    // Add absolute values function
    function [N-1:0] abs_add;
        input [N-1:0] a_in;
        input [N-1:0] b_in;
        reg [N-1:0] abs_a, abs_b;
        reg [N:0] sum_full; // one extra bit for overflow
        begin
            abs_a = abs_val(a_in);
            abs_b = abs_val(b_in);
            sum_full = abs_a + abs_b;
            // If overflow, we just truncate to N bits (saturate or wrap is not specified)
            abs_add = sum_full[N-1:0];
        end
    endfunction

    // Subtract absolute values function: abs(a) - abs(b), assuming abs(a) >= abs(b)
    function [N-1:0] abs_sub;
        input [N-1:0] a_in;
        input [N-1:0] b_in;
        reg [N-1:0] abs_a, abs_b;
        reg [N-1:0] diff;
        begin
            abs_a = abs_val(a_in);
            abs_b = abs_val(b_in);
            diff = abs_a - abs_b;
            abs_sub = diff;
        end
    endfunction

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign -> add absolute values, sign bit same as a/b
            res = abs_add(a,b);
            res[N-1] = a[N-1];
        end else begin
            // Different signs -> subtract smaller abs from bigger abs
            if (abs_greater(a,b)) begin
                // a has greater abs
                res = abs_sub(a,b);
                // Sign bit set to 0 for positive as per instruction
                res[N-1] = 1'b0;
            end else if (abs_greater(b,a)) begin
                // b has greater abs
                res = abs_sub(b,a);
                // Sign bit: if result zero set 0 else negative (1)
                if (res[N-2:0] == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = 1'b1;
            end else begin
                // abs(a) == abs(b), result zero
                res = {N{1'b0}};
            end
        end
    end

    assign c = res;

endmodule