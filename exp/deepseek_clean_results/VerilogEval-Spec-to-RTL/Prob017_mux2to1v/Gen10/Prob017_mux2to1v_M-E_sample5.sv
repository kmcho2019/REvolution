module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate 10 slices of 10 bits each
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice
            // Each slice handles 10 bits
            wire [9:0] slice_a = a[(i*10)+9 : i*10];
            wire [9:0] slice_b = b[(i*10)+9 : i*10];
            wire [9:0] slice_out;
            
            // Individual slice mux
            assign slice_out = sel ? slice_b : slice_a;
            
            // Connect slice output
            assign out[(i*10)+9 : i*10] = slice_out;
        end
    endgenerate

endmodule