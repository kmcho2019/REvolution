module fixed_point_subtractor #(
    parameter N = 32,    // Total bits
    parameter Q = 16     // Fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Local parameters for clarity
    localparam INT_BITS = N - Q;  // Integer bits
    
    // Two's complement subtraction with carry out
    wire [N:0] sub_result = {1'b0, a} + {1'b0, ~b} + 1'b1;
    wire [N-1:0] raw_result = sub_result[N-1:0];
    wire carry_out = sub_result[N];
    
    // Zero detection (OR reduction)
    wire is_zero = ~(|raw_result);
    
    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    always @(*) begin
        if (is_zero) begin
            c = {1'b0, {(N-1){1'b0}};  // Positive zero
        end
        else if (a_sign == b_sign) begin
            c = raw_result;  // Same signs - result sign matches inputs
        end
        else begin
            // Different signs - use carry out to determine sign
            c = {~carry_out, raw_result[N-2:0]};
        end
    end

endmodule