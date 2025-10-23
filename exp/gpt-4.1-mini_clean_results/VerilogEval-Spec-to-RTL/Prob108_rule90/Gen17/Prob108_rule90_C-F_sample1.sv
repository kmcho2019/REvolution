module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // left boundary (0 if no neighbor)
    input  wire        right_in,   // right boundary (0 if no neighbor)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;
    wire        ce;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in    : q_out[i-1];
            wire right = (i == 63)  ? right_in   : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable: update when loading or state changes
    assign ce = load | |(next_state ^ q_out);

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
        // Assign boundaries with zero padding at edges
        for (i = 0; i < 8; i = i + 1) begin : assign_bounds
            assign left_bounds[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

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
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule