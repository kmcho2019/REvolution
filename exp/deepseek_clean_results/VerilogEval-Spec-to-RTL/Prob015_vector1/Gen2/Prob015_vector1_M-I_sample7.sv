module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Explicit wire declarations (optional clarity)
    wire [15:0] in_w = in;
    
    // Optimal bit-slicing assignments
    assign out_hi = in_w[15:8];
    assign out_lo = in_w[7:0];

endmodule