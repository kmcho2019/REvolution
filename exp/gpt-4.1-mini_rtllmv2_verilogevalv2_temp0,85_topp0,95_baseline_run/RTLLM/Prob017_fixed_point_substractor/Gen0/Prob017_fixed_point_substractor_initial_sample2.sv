module fixed_point_subtractor #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result magnitude (unsigned for intermediate calculations)
    reg [N-1:0] res;
    reg sign_a, sign_b, sign_res;
    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] add_res, sub_res;
    reg [N-1:0] mag_res; // magnitude of result before sign application

    // Function to get absolute value of two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        abs_a  = abs_val(a);
        abs_b  = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: magnitude = abs_a - abs_b
            if (abs_a >= abs_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;
            end else begin
                mag_res = abs_b - abs_a;
                sign_res = sign_a; // sign same as inputs per instruction
            end
        end else begin
            // Different sign: add absolute values
            add_res = abs_a + abs_b;
            // Determine sign based on which is larger in absolute value
            if (abs_a >= abs_b)
                sign_res = sign_a;
            else
                sign_res = sign_b;
            mag_res = add_res;
        end

        // Handle zero result: sign bit forced to 0
        if (mag_res == {N{1'b0}}) begin
            res = {1'b0, {N-1{1'b0}}};
        end else begin
            // Apply sign: if sign_res=1, take two's complement of magnitude
            if (sign_res == 1'b1)
                res = (~mag_res + 1'b1);
            else
                res = mag_res;
        end

        c = res;
    end

endmodule