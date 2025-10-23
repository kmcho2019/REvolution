module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,         // left boundary (0 if no neighbor)
    input right_in,        // right boundary (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;
    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left = (i == 0)   ? left_in   : q_out[i - 1];
            wire right= (i == 63)  ? right_in  : q_out[i + 1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Enable update only if load or next_state differs from current state
    wire update_en = load | (| (q_out ^ next_state));

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (update_en)
            q_out <= next_state;
        // else retain current state without toggling register bits
    end
endmodule

module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    // Instantiate wires for 8 blocks outputs
    wire [63:0] block_q [7:0];

    // Boundary wires between blocks
    wire [6:0] inter_block_left;  // left boundary inputs for blocks 1..7 from prev block's MSB
    wire [6:0] inter_block_right; // right boundary inputs for blocks 0..6 from next block's LSB

    // Connect boundaries directly:
    // left_in of block 0 = 0 (boundary condition)
    // right_in of block 7 = 0 (boundary condition)
    // For other blocks: left_in = MSB of previous block q_out
    //                   right_in = LSB of next block q_out
    assign inter_block_left = {block_q[6][63], block_q[5][63], block_q[4][63], block_q[3][63],
                              block_q[2][63], block_q[1][63], block_q[0][63]};
    assign inter_block_right = {block_q[1][0], block_q[2][0], block_q[3][0], block_q[4][0],
                               block_q[5][0], block_q[6][0], block_q[7][0]};

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            wire left_bound = (i == 0) ? 1'b0 : inter_block_left[i - 1];
            wire right_bound = (i == 7) ? 1'b0 : inter_block_right[i];

            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bound),
                .right_in(right_bound),
                .q_out(block_q[i])
            );

            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule