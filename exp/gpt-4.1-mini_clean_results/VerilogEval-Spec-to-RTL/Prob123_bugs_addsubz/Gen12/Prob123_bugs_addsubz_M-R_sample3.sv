module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Conditionally invert b based on do_sub
    wire [7:0] b_xor = b ^ {8{do_sub}};

    // Add a and b_xor plus do_sub (to add 1 when subtracting)
    wire [8:0] sum = a + b_xor + do_sub;

    assign out = sum[7:0];
    assign result_is_zero = ~|sum[7:0];

endmodule