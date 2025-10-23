module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Use signed subtraction via conditional negation for subtraction
        out = do_sub ? (a - b) : (a + b);
        // Zero flag is set if out is zero, else cleared
        result_is_zero = ~|out;
    end

endmodule