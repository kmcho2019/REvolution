module fixed_point_subtractor #(parameter Q = 16, parameter N = 32) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed representations of inputs
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    reg signed [N-1:0] res;

    // Helper wires for sign and absolute values
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of a and b
    wire signed [N-1:0] a_abs = a_sign ? -a_signed : a_signed;
    wire signed [N-1:0] b_abs = b_sign ? -b_signed : b_signed;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a - b
            res = a_signed - b_signed;
        end else begin
            // Different sign: add absolute values and assign sign based on comparison
            if (a_abs >= b_abs) begin
                res = a_sign ? -(a_abs - b_abs) : (a_abs - b_abs);
            end else begin
                res = b_sign ? (b_abs - a_abs) : -(b_abs - a_abs);
            end
        end

        // Handle zero result: explicitly set sign bit to 0
        if (res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end
        c = res;
    end

endmodule