module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,       // left neighbor boundary (0 for leftmost block)
    input  wire        right_in,      // right neighbor boundary (0 for rightmost block)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : calc_next
            wire left  = (i == 0)   ? left_in    : q_out[i-1];
            wire right = (i == 63)  ? right_in   : q_out[i+1];
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
    localparam NUM_BLOCKS = 8;
    localparam BLOCK_SIZE = 64;

    // Block states
    wire [BLOCK_SIZE-1:0] block_q [NUM_BLOCKS-1:0];

    // Boundary registers: registered boundary bits from each block for next cycle inputs
    reg  [NUM_BLOCKS-1:0] left_bounds_reg;
    reg  [NUM_BLOCKS-1:0] right_bounds_reg;

    // Boundary inputs to each block for next state computation
    wire [NUM_BLOCKS-1:0] left_bounds;
    wire [NUM_BLOCKS-1:0] right_bounds;

    // Initial boundary conditions: external boundaries are zero
    // Left boundary of block 0 is always zero
    assign left_bounds[0] = 1'b0;
    // Right boundary of last block is zero
    assign right_bounds[NUM_BLOCKS-1] = 1'b0;

    // For internal blocks, boundaries come from registered neighbors
    genvar i;
    generate
        for (i = 1; i < NUM_BLOCKS; i = i + 1) begin : left_bound_assign
            assign left_bounds[i] = right_bounds_reg[i-1];
        end
        for (i = 0; i < NUM_BLOCKS-1; i = i + 1) begin : right_bound_assign
            assign right_bounds[i] = left_bounds_reg[i+1];
        end
    endgenerate

    // Instantiate blocks
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : blocks
            // Gate load signal per block for better power optimization (optional)
            wire block_load = load;

            Rule90Block64 block (
                .clk(clk),
                .load(block_load),
                .data_in(data[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*BLOCK_SIZE +: BLOCK_SIZE] = block_q[i];
        end
    endgenerate

    // Update boundary registers on clock edge after block_q updates
    always @(posedge clk) begin
        if (load) begin
            // On load, load boundary registers directly from loaded data
            // Left boundary of each block is the block_q leftmost bit after loading
            // Similarly for right boundary
            left_bounds_reg  <= {NUM_BLOCKS{1'b0}};
            right_bounds_reg <= {NUM_BLOCKS{1'b0}};
            // Instead, set boundaries from data input bits (registered after load)
            // For each block:
            integer j;
            for (j = 0; j < NUM_BLOCKS; j = j + 1) begin
                // left boundary bit of block j = data[j*64]
                left_bounds_reg[j]  <= data[j*BLOCK_SIZE];
                // right boundary bit of block j = data[(j+1)*64 -1]
                right_bounds_reg[j] <= data[(j+1)*BLOCK_SIZE - 1];
            end
        end else begin
            // Update boundary registers from adjacent blocks' outputs for next cycle
            integer k;
            for (k = 0; k < NUM_BLOCKS; k = k + 1) begin
                // Left boundary bit = leftmost bit of block_q[k]
                left_bounds_reg[k]  <= block_q[k][0];
                // Right boundary bit = rightmost bit of block_q[k]
                right_bounds_reg[k] <= block_q[k][BLOCK_SIZE-1];
            end
        end
    end
endmodule