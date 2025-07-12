module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // left boundary (0 if none)
    input  wire        right_in,   // right boundary (0 if none)
    output reg  [63:0] q_out
);
    // Intermediate wire for next state computation
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in    : q_out[i-1];
            wire right = (i == 63)  ? right_in   : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Synchronous update with nonblocking assignments
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
    // Internal state wires for each 64-bit block
    wire [63:0] block_q [7:0];

    // Boundary inputs for each block
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    genvar i;
    generate
        // Assign boundaries with zero at the edges; internal boundaries connected between blocks
        for (i = 0; i < 8; i = i + 1) begin : assign_boundaries
            assign left_bounds[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    generate
        // Instantiate 8 blocks of Rule90Block64 for 512 cells total
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