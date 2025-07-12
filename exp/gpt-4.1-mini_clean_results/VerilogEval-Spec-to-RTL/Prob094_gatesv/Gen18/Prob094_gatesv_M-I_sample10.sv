module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    wire [3:0] left_neighbor;
    wire [3:0] right_neighbor;

    // Define neighbors with boundary conditions:
    // For out_both: neighbor to the left is in[i+1], set last to 0 (no neighbor)
    assign left_neighbor = {in[2:0], 1'b0};

    // For out_any: neighbor to the right is in[i-1], set first to 0 (no neighbor)
    assign right_neighbor = {1'b0, in[3:1]};

    // out_both[i] = in[i] & left_neighbor[i], last bit zero as per spec
    assign out_both = in & left_neighbor;

    // out_any[i] = in[i] | right_neighbor[i], first bit zero as per spec
    assign out_any = in | right_neighbor;

    // For out_different, neighbor to the left with wrap-around:
    // left neighbor of in[i] is in[(i+1)%4], so rotate left by 1
    assign out_different = in ^ {in[2:0], in[3]};

endmodule