module fixed_point_subtractor #(
    parameter N = 32,    // Total bits
    parameter Q = 16     // Fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire [N-1:0] b_comp = ~b + 1'b1;  // Two's complement of b
    wire [N-1:0] raw_result = a + b_comp;
    
    // Sign comparison
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire same_sign = ~(a_sign ^ b_sign);
    
    // Zero detection
    wire is_zero = (raw_result == {N{1'b0}});
    
    always @(*) begin
        if (is_zero) begin
            c = {1'b0, {(N-1){1'b0}}};  // Force positive zero
        end
        else if (same_sign) begin
            c = raw_result;  // Result has same sign as inputs
        end
        else begin
            // Different signs - result sign depends on magnitude
            if (a_sign) begin
                c = (a[N-2:0] > b[N-2:0]) ? 
                    {1'b1, raw_result[N-2:0]} : 
                    {1'b0, raw_result[N-2:0]};
            end
            else begin
                c = (a[N-2:0] > b[N-2:0]) ? 
                    {1'b0, raw_result[N-2:0]} : 
                    {1'b1, raw_result[N-2:0]};
            end
        end
    end

endmodule