module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Compute either addition or subtraction based on do_sub
        out = do_sub ? (a - b) : (a + b);

        // Set zero flag: 1 if out is zero, else 0
        result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule