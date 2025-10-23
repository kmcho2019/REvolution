module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // One-hot decoder
    wire [255:0] sel_onehot;
    assign sel_onehot = (256'b1 << sel);

    // Tri-state equivalent using AND-OR logic
    // Each AND gate selects one input when its select line is high
    // The OR of all AND outputs gives the final result
    wire [255:0] selected_bits;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : bit_select
            assign selected_bits[i] = in[i] & sel_onehot[i];
        end
    endgenerate

    // OR reduction of all selected bits
    // Since only one bit can be selected at a time, this is equivalent to mux output
    assign out = |selected_bits;

endmodule