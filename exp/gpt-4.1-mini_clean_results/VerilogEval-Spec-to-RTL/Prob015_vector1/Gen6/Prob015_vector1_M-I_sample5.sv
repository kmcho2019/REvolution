module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Direct assignments for splitting the input
    assign out_lo = in[7:0];
    assign out_hi = in[15:8];

endmodule