module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Compute output using ternary operator: add if do_sub=0, subtract if do_sub=1
        out = do_sub ? (a - b) : (a + b);

        // Set zero flag explicitly for all cases to avoid latch
        result_is_zero = (out == 8'd0) ? 1'b1 : 1'b0;
    end

endmodule