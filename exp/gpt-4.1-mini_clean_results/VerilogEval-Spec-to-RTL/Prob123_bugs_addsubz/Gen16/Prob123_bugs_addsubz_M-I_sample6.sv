module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Compute result using built-in '+' and '-' operators based on do_sub control signal
    assign out = do_sub ? (a - b) : (a + b);

    // Zero flag: reduction NOR of the output bits
    assign result_is_zero = ~|out;

endmodule