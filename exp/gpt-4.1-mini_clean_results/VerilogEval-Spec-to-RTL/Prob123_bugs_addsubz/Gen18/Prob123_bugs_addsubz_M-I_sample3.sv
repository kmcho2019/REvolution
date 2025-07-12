module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        out = do_sub ? (a - b) : (a + b);
        result_is_zero = ~|out;  // Reduction NOR to detect zero
    end

endmodule