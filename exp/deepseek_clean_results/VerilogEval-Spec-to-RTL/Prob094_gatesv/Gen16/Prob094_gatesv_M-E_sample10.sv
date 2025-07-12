module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create rotated version of input (left neighbor becomes current bit)
    wire [3:0] rotated_in = {in[0], in[3:1]};

    // Compute all neighbor relationships in parallel
    wire [3:0] both_neighbors = in & rotated_in;
    wire [3:0] any_neighbors = in | rotated_in;
    wire [3:0] diff_neighbors = in ^ rotated_in;

    // Assign outputs with proper bit selection
    assign out_both = {1'b0, both_neighbors[2:0]};
    assign out_any = {any_neighbors[3:1], 1'b0};
    assign out_different = diff_neighbors;

endmodule