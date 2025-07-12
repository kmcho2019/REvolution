module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Use behavioral arithmetic operators for adder-subtractor
        out = do_sub ? (a - b) : (a + b);

        // Correct zero flag: 1 if out == 0, else 0
        result_is_zero = ~|out;
    end

endmodule