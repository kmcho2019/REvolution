module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction using two's complement logic
        if (do_sub)
            out = a + (~b) + 1'b1;  // subtraction: a + (~b + 1)
        else
            out = a + b;            // addition

        // Set zero flag correctly for all cases
        if (out == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule