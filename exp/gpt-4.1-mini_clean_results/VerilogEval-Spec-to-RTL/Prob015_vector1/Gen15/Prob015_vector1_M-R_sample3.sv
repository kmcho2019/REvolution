module TopModule (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Directly assign the high and low bytes from the input vector
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule