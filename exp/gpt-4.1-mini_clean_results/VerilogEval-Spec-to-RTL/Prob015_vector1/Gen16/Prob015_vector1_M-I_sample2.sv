module TopModule (
    input  wire [15:0] in,
    output wire [7:0]  out_hi,
    output wire [7:0]  out_lo
);
    // Directly assign upper and lower bytes from input for flat, optimal design
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule