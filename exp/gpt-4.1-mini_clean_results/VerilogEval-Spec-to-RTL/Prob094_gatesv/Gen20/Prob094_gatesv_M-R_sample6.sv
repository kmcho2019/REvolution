module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Define left neighbors for each bit (wrap around for bit 3)
    wire [3:0] left_neighbor;
    assign left_neighbor = {in[0], in[3:1]}; // left neighbor of bit 3 is bit 0

    // Define right neighbors for each bit (no wrap-around, right neighbor of bit 0 is none)
    wire [3:0] right_neighbor;
    assign right_neighbor = {1'b0, in[3:1]}; // right neighbor of bit 0 = 0 (no neighbor)

    // out_both: both bit and its left neighbor are 1; bits 0..2; bit 3 = 0 (no left neighbor)
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any: either bit or its right neighbor is 1; bits 1..3; bit 0 = 0 (no right neighbor)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different: bit XOR left neighbor with wrap-around as defined
    assign out_different = in ^ left_neighbor;

endmodule