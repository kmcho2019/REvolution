module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    wire [7:0] b_xor = b ^ {8{do_sub}};          // Conditionally invert B if subtracting
    wire [8:0] sum = a + b_xor + do_sub;         // Perform add or subtract with carry-in do_sub

    assign out = sum[7:0];
    assign result_is_zero = ~|sum[7:0];           // Zero flag using reduction NOR

endmodule