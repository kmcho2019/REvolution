module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Block processing approach
    reg [255:0] next_q;
    wire [15:0] block_ready;
    reg [3:0] processing_block;

    // Process grid in 4x4 blocks (16 total blocks)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            processing_block <= 0;
        end else begin
            // Rotate through blocks each cycle
            processing_block <= (processing_block == 15) ? 0 : processing_block + 1;
            
            // Update only the current block's cells
            for (integer i = 0; i < 16; i = i + 1) begin
                if (i/4 == processing_block[3:2] && (i%4) == processing_block[1:0]) begin
                    q[i*16 +: 16] <= next_q[i*16 +: 16];
                end
            end
        end
    end

    // Generate processing logic for each 4x4 block
    genvar block_row, block_col;
    generate
        for (block_row = 0; block_row < 4; block_row = block_row + 1) begin : block_row_loop
            for (block_col = 0; block_col < 4; block_col = block_col + 1) begin : block_col_loop
                // Calculate neighbor counts for all cells in this block
                wire [15:0][3:0] block_neighbor_counts;
                
                for (integer row = 0; row < 4; row = row + 1) begin : block_row_cells
                    for (integer col = 0; col < 4; col = col + 1) begin : block_col_cells
                        // Global coordinates with wrap-around
                        wire [3:0] global_row = {block_row[1:0], row[1:0]};
                        wire [3:0] global_col = {block_col[1:0], col[1:0]};
                        
                        // Calculate all 8 neighbors with wrap-around
                        wire [3:0] row_m1 = global_row - 1;
                        wire [3:0] row_p1 = global_row + 1;
                        wire [3:0] col_m1 = global_col - 1;
                        wire [3:0] col_p1 = global_col + 1;
                        
                        // Sum neighbors using optimized bit selection
                        assign block_neighbor_counts[row*4 + col] = 
                            q[row_m1*16 + col_m1] + q[row_m1*16 + global_col] + q[row_m1*16 + col_p1] +
                            q[global_row*16 + col_m1] + q[global_row*16 + col_p1] +
                            q[row_p1*16 + col_m1] + q[row_p1*16 + global_col] + q[row_p1*16 + col_p1];
                    end
                end
                
                // Speculative next state calculation for all cells in block
                always @(*) begin
                    for (integer i = 0; i < 16; i = i + 1) begin
                        case (block_neighbor_counts[i])
                            4'd0, 4'd1: next_q[(block_row*4 + i/4)*16 + block_col*4 + i%4] = 1'b0;
                            4'd2: next_q[(block_row*4 + i/4)*16 + block_col*4 + i%4] = 
                                    q[(block_row*4 + i/4)*16 + block_col*4 + i%4];
                            4'd3: next_q[(block_row*4 + i/4)*16 + block_col*4 + i%4] = 1'b1;
                            default: next_q[(block_row*4 + i/4)*16 + block_col*4 + i%4] = 1'b0;
                        endcase
                    end
                end
            end
        end
    endgenerate

endmodule