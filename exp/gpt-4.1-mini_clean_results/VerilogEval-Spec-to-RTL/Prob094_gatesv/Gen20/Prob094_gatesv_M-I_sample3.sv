module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Define neighbor vectors for clarity and potential synthesis optimization
    wire [3:0] left_neighbor  = {in[0], in[3:1]};  // wrap-around left neighbor for out_different
    wire [3:0] left_neighbor_nobit3 = {1'b0, in[3:1]}; // left neighbor with 0 padded at bit 0 for out_both
    wire [3:0] right_neighbor_nobit0 = {in[2:0], 1'b0}; // right neighbor with 0 padded at bit 3 for out_any

    // (1) out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3]=0
    assign out_both = in & left_neighbor_nobit3;

    // (2) out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0]=0
    assign out_any = in | right_neighbor_nobit0;

    // (3) out_different[i] = in[i] ^ in[(i+1)%4] (wrap-around)
    assign out_different = in ^ left_neighbor;

endmodule