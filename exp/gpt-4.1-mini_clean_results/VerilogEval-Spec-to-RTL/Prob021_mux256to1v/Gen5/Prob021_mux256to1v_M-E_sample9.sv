module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Select the 4-bit slice indexed by sel using part-select with dynamic offset
    assign out = in[sel*4 +: 4];

endmodule