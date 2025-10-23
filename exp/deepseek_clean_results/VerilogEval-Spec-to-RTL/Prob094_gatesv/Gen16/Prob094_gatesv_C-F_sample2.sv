module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[2:0]: Current bit AND left neighbor (in[3] has no left neighbor)
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3]   = 1'b0;  // Not required per spec

    // out_any[3:1]: Current bit OR right neighbor (in[0] has no right neighbor)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0]   = 1'b0;   // Not required per spec

    // out_different: Current bit XOR left neighbor (with circular wrap-around)
    wire [3:0] left_neighbor = {in[0], in[3:1]};  // Circular shift right
    assign out_different = in ^ left_neighbor;

endmodule