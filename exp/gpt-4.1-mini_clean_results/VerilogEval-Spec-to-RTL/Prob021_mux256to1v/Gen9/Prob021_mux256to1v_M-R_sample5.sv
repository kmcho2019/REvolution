module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Calculate base index as sel * 4
    wire [10:0] base_idx = sel << 2;

    // Assign each bit of output directly from corresponding input bit
    assign out[0] = in[base_idx + 0];
    assign out[1] = in[base_idx + 1];
    assign out[2] = in[base_idx + 2];
    assign out[3] = in[base_idx + 3];

endmodule