module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Unpack input into 256 4-bit elements
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_unpack
            assign in_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Four groups of 64 elements each
    wire [3:0] group_mux_out [0:3];
    genvar g;
    generate
        for (g = 0; g < 4; g = g + 1) begin : group_mux
            // Select one of the 64 elements indexed by sel[5:0]
            assign group_mux_out[g] = in_array[g*64 + sel[5:0]];
        end
    endgenerate

    // Final 4-to-1 mux selected by sel[7:6]
    assign out = group_mux_out[sel[7:6]];

endmodule