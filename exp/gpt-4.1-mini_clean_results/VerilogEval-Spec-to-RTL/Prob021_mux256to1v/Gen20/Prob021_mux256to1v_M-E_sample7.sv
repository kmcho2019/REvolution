module TopModule (
    input  wire [1023:0] in,  // 256 inputs of 4 bits each concatenated
    input  wire [7:0]    sel, // select one of 256 inputs
    output wire [3:0]    out
);

    // Select 4 bits from `in` starting at index sel * 4
    // The +: operator selects 4 bits starting at sel*4
    assign out = in[sel*4 +: 4];

endmodule