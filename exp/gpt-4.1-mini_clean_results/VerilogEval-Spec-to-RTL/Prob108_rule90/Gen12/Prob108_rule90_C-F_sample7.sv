module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // left boundary (0 if none)
    input  wire        right_in,   // right boundary (0 if none)
    output reg  [63:0] q_out
);
    // Compute next state: next bit = left neighbor XOR right neighbor
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_bits
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Detect if state changed to gate register update
    wire state_changed = |(q_out ^ next_state);
    wire clk_en = load | state_changed;

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (clk_en)
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal 64-bit block outputs
    wire [63:0] block_q [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : blocks
            // Left boundary input: zero if first block, else rightmost bit of left block
            wire left_in  = (i == 0) ? 1'b0 : block_q[i-1][63];
            // Right boundary input: zero if last block, else leftmost bit of right block
            wire right_in = (i == 7) ? 1'b0 : block_q[i+1][0];

            Rule90Block64 blk (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_in),
                .right_in(right_in),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule