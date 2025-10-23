module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_mux;
    wire [7:0] sum;

    // Conditional inversion of b for subtraction (two's complement)
    assign b_mux = do_sub ? ~b : b;

    // Perform addition or subtraction with carry_in = do_sub
    assign sum = a + b_mux + do_sub;

    // Register output and zero flag in a single always block to reduce glitches
    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;  // zero flag computed from combinational sum to minimize latency
    end

endmodule