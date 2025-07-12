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

        // Use reduction NOR to detect zero output for better synthesis mapping
        result_is_zero = ~|out;
    end

endmodule