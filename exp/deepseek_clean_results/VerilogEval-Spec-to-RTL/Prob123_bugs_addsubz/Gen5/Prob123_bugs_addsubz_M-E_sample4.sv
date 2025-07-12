module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Parallel computation paths
    wire [7:0] sum_add = a + b;
    wire [7:0] sum_sub = a - b;
    
    // Early zero detection
    wire zero_add = ~(|sum_add);
    wire zero_sub = ~(|sum_sub);
    
    // Result selection with gating
    always @(*) begin
        if (do_sub) begin
            out = sum_sub;
            result_is_zero = zero_sub;
        end else begin
            out = sum_add;
            result_is_zero = zero_add;
        end
    end

endmodule