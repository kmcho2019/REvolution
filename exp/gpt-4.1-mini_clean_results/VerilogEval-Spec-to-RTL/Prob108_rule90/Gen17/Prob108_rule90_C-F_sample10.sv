module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    // Compute next state bits as XOR of left and right neighbors
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Synchronous update: load data_in if load is high; else update to next_state.
    // Always update registers each cycle without clock enable gating for timing and simplicity.
    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal 64-bit blocks q outputs
    wire [63:0] block_q [7:0];

    // Boundary signals for each block
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Explicit boundary assignments for clarity and synthesis friendliness
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