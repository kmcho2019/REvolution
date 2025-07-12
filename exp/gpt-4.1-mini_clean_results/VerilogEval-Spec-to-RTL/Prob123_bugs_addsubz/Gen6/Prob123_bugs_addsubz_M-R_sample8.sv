module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum;

    assign b_xor = b ^ {8{do_sub}};                  // Conditional invert of B if do_sub=1
    assign sum = {1'b0, a} + {1'b0, b_xor} + do_sub;  // Add a + b_xor + do_sub (carry-in)
    assign out = sum[7:0];                            // Result is lower 8 bits of sum
    assign result_is_zero = ~|out;                    // Zero flag is reduction NOR of out bits

endmodule