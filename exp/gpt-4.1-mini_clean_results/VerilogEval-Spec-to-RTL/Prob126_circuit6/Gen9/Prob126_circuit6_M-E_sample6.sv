module TopModule (
    input  [2:0] a,
    output [15:0] q
);
    wire [7:0] one_hot;

    // 3-to-8 decoder: one_hot[i] is high if a==i
    assign one_hot = 8'b1 << a;

    // Define each output pattern
    wire [15:0] val0 = 16'h1232;
    wire [15:0] val1 = 16'haee0;
    wire [15:0] val2 = 16'h27d4;
    wire [15:0] val3 = 16'h5a0e;
    wire [15:0] val4 = 16'h2066;
    wire [15:0] val5 = 16'h64ce;
    wire [15:0] val6 = 16'hc526;
    wire [15:0] val7 = 16'h2f19;

    // Combine outputs by ANDing each constant with corresponding one_hot bit, then OR together
    assign q =
        ({16{one_hot[0]}} & val0) |
        ({16{one_hot[1]}} & val1) |
        ({16{one_hot[2]}} & val2) |
        ({16{one_hot[3]}} & val3) |
        ({16{one_hot[4]}} & val4) |
        ({16{one_hot[5]}} & val5) |
        ({16{one_hot[6]}} & val6) |
        ({16{one_hot[7]}} & val7);

endmodule