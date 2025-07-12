module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Assign output high byte by slicing upper 8 bits of 'in'
    assign out_hi = in[15:8];

    // Assign output low byte by slicing lower 8 bits of 'in'
    assign out_lo = in[7:0];

endmodule