module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-2:0] abs_a; // absolute value of a (excluding sign bit)
    reg [N-2:0] abs_b; // absolute value of b (excluding sign bit)
    reg [N-2:0] abs_res; // absolute value of result (excluding sign bit)
    reg sign_a, sign_b, sign_res;
    reg [N-2:0] larger_abs;
    reg [N-2:0] smaller_abs;

    // Function to compute absolute value of fixed-point two's complement number
    function [N-2:0] abs_val;
        input [N-1:0] val;
        reg [N-1:0] inverted;
        begin
            if(val[N-1] == 1'b0) begin
                abs_val = val[N-2:0];
            end else begin
                inverted = ~val + 1'b1;
                abs_val = inverted[N-2:0];
            end
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if(sign_a == sign_b) begin
            // Same sign: add absolute values
            abs_res = abs_a + abs_b;
            sign_res = sign_a;
            // Handle overflow by truncating abs_res to N-1 bits
            // If carry out, it is ignored (wrap-around), as per two's complement
        end else begin
            // Different sign: subtract smaller absolute value from larger absolute value
            if(abs_a >= abs_b) begin
                abs_res = abs_a - abs_b;
                sign_res = sign_a;
            end else begin
                abs_res = abs_b - abs_a;
                sign_res = sign_b;
            end
        end

        // Compose the final result
        c = {sign_res, abs_res};
    end

endmodule