module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    
    // Calculate total shift amount (0-7)
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);
    
    // Generate each output bit by selecting appropriate input bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate
            // Calculate source index with wrap-around
            wire [2:0] src_idx = i - shift_amount;
            // Select the appropriate bit using multiplexers
            assign out[i] = in[src_idx[2:0]];
        end
    endgenerate
endmodule