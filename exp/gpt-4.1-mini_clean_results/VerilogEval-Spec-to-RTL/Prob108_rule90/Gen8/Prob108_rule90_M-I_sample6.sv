module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left boundary (0 if no neighbor)
    input right_in,       // right boundary (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left = (i == 0)   ? left_in  : q_out[i-1];
            wire right= (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable simplified: update when load is active or always update next_state
    // Removed (q_out != next_state) to simplify clock enable logic
    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    // Signals for each 64-bit block output
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Explicit boundary assignments for clarity and simpler wiring
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[0] = block_q[1][0];
    assign left_bounds[1]  = block_q[0][63];
    assign right_bounds[1] = block_q[2][0];
    assign left_bounds[2]  = block_q[1][63];
    assign right_bounds[2] = block_q[3][0];
    assign left_bounds[3]  = block_q[2][63];
    assign right_bounds[3] = block_q[4][0];
    assign left_bounds[4]  = block_q[3][63];
    assign right_bounds[4] = block_q[5][0];
    assign left_bounds[5]  = block_q[4][63];
    assign right_bounds[5] = block_q[6][0];
    assign left_bounds[6]  = block_q[5][63];
    assign right_bounds[6] = block_q[7][0];
    assign left_bounds[7]  = block_q[6][63];
    assign right_bounds[7] = 1'b0;

    // Instantiate eight 64-bit Rule90 blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule