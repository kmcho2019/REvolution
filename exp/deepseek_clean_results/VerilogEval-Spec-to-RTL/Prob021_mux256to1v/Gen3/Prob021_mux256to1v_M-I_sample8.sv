module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16x 16:1 muxes
    wire [3:0] stage1 [15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1_muxes
            // Each stage1 mux selects one of 16 4-bit inputs
            assign stage1[i] = in[( (i << 6) + (sel[3:0] << 2) +: 4];
        end
    endgenerate

    // Second level: 16:1 mux
    assign out = stage1[sel[7:4]];

endmodule