module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular shift register for neighbor access
    wire [3:0] left_neighbor = {in[0], in[3:1]};
    wire [3:0] right_neighbor = {in[2:0], in[3]};

    // Configurable processing blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : proc_block
            // out_both: AND with left neighbor (except for MSB)
            assign out_both[i] = (i == 3) ? 1'bx : (in[i] & left_neighbor[i]);
            
            // out_any: OR with right neighbor (except for LSB)
            assign out_any[i] = (i == 0) ? 1'bx : (in[i] | right_neighbor[i]);
            
            // out_different: XOR with left neighbor (wrap-around)
            assign out_different[i] = in[i] ^ left_neighbor[i];
        end
    endgenerate

endmodule