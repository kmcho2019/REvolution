module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND with left neighbor (bit 99 = 0)
    assign out_both[99] = 1'b0;  // Boundary condition
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : both_gen
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any: OR with right neighbor (bit 0 = 0)
    assign out_any[0] = 1'b0;  // Boundary condition
    genvar j;
    generate
        for (j = 1; j < 100; j = j + 1) begin : any_gen
            assign out_any[j] = in[j] | in[j-1];
        end
    endgenerate

    // out_different: XOR with left neighbor (wrap-around)
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule