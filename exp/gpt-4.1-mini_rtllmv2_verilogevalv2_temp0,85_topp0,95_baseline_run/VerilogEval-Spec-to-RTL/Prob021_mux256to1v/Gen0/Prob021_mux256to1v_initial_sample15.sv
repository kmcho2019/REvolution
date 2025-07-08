module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Calculate starting index for slicing
    wire [9:0] start_bit = sel * 4;

    // Select 4 bits starting from start_bit
    assign out = in[start_bit +: 4];

endmodule