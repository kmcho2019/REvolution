module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Clock enable: update on load or on every cycle (can be modified for gating)
    wire update_enable = load | 1'b1; // Here always 1 to advance every cycle; can gate if needed

    // Split q and next_state into 8 blocks of 64 bits
    localparam BLOCKS = 8;
    localparam BLOCK_SIZE = 64;

    wire [511:0] next_state;

    genvar block, i;
    generate
        for (block = 0; block < BLOCKS; block = block + 1) begin : block_loop
            wire [BLOCK_SIZE-1:0] q_block = q[block*BLOCK_SIZE +: BLOCK_SIZE];

            for (i = 0; i < BLOCK_SIZE; i = i + 1) begin : cell_loop
                wire left_neighbor;
                wire right_neighbor;

                // Calculate global index for neighbors
                localparam integer idx = block*BLOCK_SIZE + i;

                assign left_neighbor  = (idx == 0)        ? 1'b0 : q[idx-1];
                assign right_neighbor = (idx == 511)      ? 1'b0 : q[idx+1];

                assign next_state[idx] = left_neighbor ^ right_neighbor;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (update_enable)
            q <= next_state;
        // else hold state to reduce toggling if clock gating or enable is used
    end

endmodule