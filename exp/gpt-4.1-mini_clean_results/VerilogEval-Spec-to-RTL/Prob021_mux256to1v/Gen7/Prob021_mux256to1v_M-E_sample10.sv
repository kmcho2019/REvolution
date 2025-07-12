module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Unpack input vector into 256 4-bit elements
    wire [3:0] stage [0:8][0:255]; 
    // stage 0 holds the input elements: 256 elements

    genvar i, lvl;
    generate
        for (i = 0; i < 256; i = i + 1) begin : unpack_input
            assign stage[0][i] = in[i*4 +:4];
        end
    endgenerate

    // Build the binary mux tree in 8 stages
    // Each stage reduces number of elements by half
    // stage 0: 256 inputs
    // stage 1: 128 mux outputs
    // ...
    // stage 8: 1 mux output (the final out)
    
    generate
        for (lvl = 0; lvl < 8; lvl = lvl + 1) begin : tree_level
            for (i = 0; i < (256 >> (lvl + 1)); i = i + 1) begin : mux2to1
                wire sel_bit = sel[lvl];
                assign stage[lvl + 1][i] = sel_bit ? stage[lvl][2*i + 1] : stage[lvl][2*i];
            end
        end
    endgenerate

    assign out = stage[8][0];

endmodule