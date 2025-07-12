module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use concatenation to create the outputs
    assign out_hi = {8'b0} | (in[15:8]);
    assign out_lo = {8'b0} | (in[7:0]);

    // Alternatively, a more straightforward approach without concatenation
    // assign out_hi = in[15:8];
    // assign out_lo = in[7:0];

endmodule