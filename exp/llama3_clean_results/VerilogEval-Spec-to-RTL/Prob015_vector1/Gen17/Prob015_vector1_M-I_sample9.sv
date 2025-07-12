// Directly assign the input bits to the output ports within the TopModule
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_hi = in[15:8]; // Directly assign the upper byte
    assign out_lo = in[7:0];  // Directly assign the lower byte

endmodule