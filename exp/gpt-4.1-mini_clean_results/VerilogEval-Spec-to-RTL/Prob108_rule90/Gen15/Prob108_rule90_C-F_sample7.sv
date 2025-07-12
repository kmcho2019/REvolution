module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,
    input  wire        right_in,
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

    // Partial compare for clock enable to reduce complexity:
    // Compare q_out and next_state in groups of 8 bits and OR their differences.
    wire [7:0] diff_groups;
    genvar g;
    generate
        for (g = 0; g < 8; g = g + 1) begin : diff_comp
            assign diff_groups[g] = |(q_out[g*8 +: 8] ^ next_state[g*8 +: 8]);
        end
    endgenerate
    wire state_changed = |diff_groups;

    wire ce = load | state_changed;

    always @(posedge clk) begin
        if (ce) begin
            if (load)
                q_out <= data_in;
            else
                q_out <= next_state;
        end
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    wire [63:0] block_q [7:0];
    wire [7:0]  left_bounds;
    wire [7:0]  right_bounds;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries
            // Left boundary of block i: zero for first block; else MSB of previous block
            assign left_bounds[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            // Right boundary of block i: zero for last block; else LSB of next block
            assign right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

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