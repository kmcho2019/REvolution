module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Use conditional operator for compactness
        out = do_sub ? (a - b) : (a + b);
        // Use bitwise NOR reduction to detect zero efficiently
        result_is_zero = ~|out;
    end

endmodule