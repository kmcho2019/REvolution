module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor = b ^ {8{do_sub}};              // Conditionally invert b
    wire [8:0] sum = {1'b0, a} + {1'b0, b_xor} + do_sub; // Single adder with carry-in

    assign out = sum[7:0];                            // Result output
    assign result_is_zero = ~|out;                    // Zero flag via reduction NOR

endmodule