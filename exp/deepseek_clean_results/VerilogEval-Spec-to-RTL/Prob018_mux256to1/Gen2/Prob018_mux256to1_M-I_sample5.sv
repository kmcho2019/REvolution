module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    wire [15:0] intermediate;

    // First level: 16 16-to-1 muxes
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level
            assign intermediate[i] = in[(i*16) + sel[3:0]];
        end
    endgenerate

    // Second level: 1 16-to-1 mux
    assign out = intermediate[sel[7:4]];
endmodule