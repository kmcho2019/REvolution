module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Split using concatenation and replication (though functionally identical)
    wire [15:0] split_wire = in;
    assign {out_hi, out_lo} = split_wire;

endmodule