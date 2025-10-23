module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Direct indexed 4-bit slice from 1024-bit input vector
    // Each 4-bit chunk corresponds to one of the 256 inputs
    // selected by the 8-bit sel signal.
    assign out = in[sel*4 +: 4];

endmodule