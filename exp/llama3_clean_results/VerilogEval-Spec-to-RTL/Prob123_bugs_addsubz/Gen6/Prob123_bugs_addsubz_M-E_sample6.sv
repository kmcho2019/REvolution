module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction based on do_sub
        out = do_sub ? (a - b) : (a + b);
        
        // Set result_is_zero flag
        // Using a direct comparison is efficient and clear
        result_is_zero = (out == 8'd0);
    end

endmodule