module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // left boundary (0 if no neighbor)
    input  wire        right_in,   // right boundary (0 if no neighbor)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_logic
            wire left  = (i == 0)   ? left_in  : q_out[i-1];
            wire right = (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

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
    // Declare regs to hold state from each block
    wire [63:0] block_q [7:0];

    // Boundary signals (left and right) for each block
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Generate boundary assignments compactly
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries
            // Left boundary of block i: 
            // for i=0 (leftmost block), boundary is 0; else MSB of previous block
            assign left_bounds[i] = (i == 0) ? 1'b0 : block_q[i-1][63];
            // Right boundary of block i:
            // for i=7 (rightmost block), boundary is 0; else LSB of next block
            assign right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Instantiate 8 blocks of Rule90Block64
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 blk (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
        end
    endgenerate

    // Flatten block outputs into q vector
    generate
        for (i = 0; i < 8; i = i + 1) begin : output_flatten
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule