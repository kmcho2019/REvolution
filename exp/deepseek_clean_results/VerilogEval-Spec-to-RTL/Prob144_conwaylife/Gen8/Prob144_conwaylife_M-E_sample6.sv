module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Neighbor counting (registered)
    reg [255:0] q_ff;
    reg [1023:0] neighbor_counts; // 4 bits per cell (16x16x4=1024)

    // Stage 2: State update
    wire [255:0] next_q;

    // Grid partitioned into 4x4 blocks (16 blocks total)
    genvar block_row, block_col;
    generate
        for (block_row = 0; block_row < 4; block_row = block_row + 1) begin : block_rows
            for (block_col = 0; block_col < 4; block_col = block_col + 1) begin : block_cols
                // Process each 4x4 block
                integer cell_row, cell_col;
                for (cell_row = 0; cell_row < 4; cell_row = cell_row + 1) begin : cell_rows
                    for (cell_col = 0; cell_col < 4; cell_col = cell_col + 1) begin : cell_cols
                        // Absolute position in grid
                        localparam abs_row = block_row*4 + cell_row;
                        localparam abs_col = block_col*4 + cell_col;
                        localparam cell_idx = abs_row*16 + abs_col;

                        // Neighbor positions with optimized wrapping
                        wire [3:0] n_row = {abs_row[3:1], (abs_row[0] ? (abs_row-1) : (abs_row+15)}; // Wrapping rows
                        wire [3:0] n_col = {abs_col[3:1], (abs_col[0] ? (abs_col-1) : (abs_col+15)}; // Wrapping cols

                        // Get all 8 neighbors (shared within block)
                        wire [7:0] neighbors;
                        assign neighbors[0] = q_ff[(n_row-1)*16 + (n_col-1)]; // top-left
                        assign neighbors[1] = q_ff[(n_row-1)*16 + n_col];     // top
                        assign neighbors[2] = q_ff[(n_row-1)*16 + (n_col+1)]; // top-right
                        assign neighbors[3] = q_ff[n_row*16 + (n_col-1)];    // left
                        assign neighbors[4] = q_ff[n_row*16 + (n_col+1)];    // right
                        assign neighbors[5] = q_ff[(n_row+1)*16 + (n_col-1)]; // bottom-left
                        assign neighbors[6] = q_ff[(n_row+1)*16 + n_col];     // bottom
                        assign neighbors[7] = q_ff[(n_row+1)*16 + (n_col+1)]; // bottom-right

                        // Parallel neighbor counting using carry-save adders
                        wire [1:0] sum_a = neighbors[0] + neighbors[1] + neighbors[2];
                        wire [1:0] sum_b = neighbors[3] + neighbors[4];
                        wire [1:0] sum_c = neighbors[5] + neighbors[6] + neighbors[7];
                        wire [3:0] count = sum_a + sum_b + sum_c;

                        // Register neighbor counts
                        always @(posedge clk) begin
                            neighbor_counts[cell_idx*4 +: 4] <= count;
                        end

                        // Next state logic
                        assign next_q[cell_idx] = (neighbor_counts[cell_idx*4 +: 4] == 3) ? 1'b1 :
                                                 (neighbor_counts[cell_idx*4 +: 4] == 2) ? q_ff[cell_idx] :
                                                 1'b0;
                    end
                end
            end
        end
    endgenerate

    // Pipeline registers and update logic
    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
            q <= data;
        end else begin
            q_ff <= q;          // Stage 1: Capture current state
            q <= next_q;        // Stage 2: Update state
        end
    end

endmodule