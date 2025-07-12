module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Intra-block neighbor counts (4x4 blocks)
    reg [255:0] q_ff;
    wire [16*16-1:0] [3:0] neighbor_counts_stage1;
    wire [255:0] changed_cells;

    // Track which cells changed last cycle
    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
            q <= data;
        end else begin
            q_ff <= q;
        end
    end

    // Delta detection
    assign changed_cells = q ^ q_ff;

    // Generate 16 blocks (4x4 each)
    genvar bx, by, i, j;
    generate
        for (bx = 0; bx < 4; bx = bx + 1) begin : block_x
            for (by = 0; by < 4; by = by + 1) begin : block_y
                // Calculate block boundaries with wrap-around
                localparam left_block = (bx == 0) ? 3 : (bx - 1);
                localparam right_block = (bx == 3) ? 0 : (bx + 1);
                localparam top_block = (by == 0) ? 3 : (by - 1);
                localparam bottom_block = (by == 3) ? 0 : (by + 1);
                
                // Process each cell in this block
                for (i = 0; i < 4; i = i + 1) begin : cell_x
                    for (j = 0; j < 4; j = j + 1) begin : cell_y
                        localparam global_x = bx*4 + i;
                        localparam global_y = by*4 + j;
                        localparam cell_idx = global_y*16 + global_x;
                        
                        // Stage 1: Count neighbors within same block
                        reg [3:0] intra_count;
                        always @(*) begin
                            intra_count = 0;
                            for (int dx = -1; dx <= 1; dx = dx + 1) begin
                                for (int dy = -1; dy <= 1; dy = dy + 1) begin
                                    if (dx == 0 && dy == 0) continue; // skip self
                                    
                                    // Wrap within block
                                    localparam nx = (i + dx + 4) % 4;
                                    localparam ny = (j + dy + 4) % 4;
                                    localparam nidx = (by*4 + ny)*16 + (bx*4 + nx);
                                    
                                    if (q[nidx]) intra_count = intra_count + 1;
                                end
                            end
                        end
                        
                        // Stage 2: Count neighbors from adjacent blocks (registered)
                        reg [3:0] inter_count;
                        reg [3:0] neighbor_count;
                        always @(posedge clk) begin
                            if (load) begin
                                inter_count <= 0;
                                neighbor_count <= 0;
                            end else begin
                                // Only update if this cell or neighbors changed
                                if (changed_cells[cell_idx] || 
                                    |changed_cells[((global_y-1+16)%16)*16 + ((global_x-1+16)%16)] ||
                                    |changed_cells[((global_y-1+16)%16)*16 + global_x] ||
                                    |changed_cells[((global_y-1+16)%16)*16 + ((global_x+1)%16)] ||
                                    |changed_cells[global_y*16 + ((global_x-1+16)%16)] ||
                                    |changed_cells[global_y*16 + ((global_x+1)%16)] ||
                                    |changed_cells[((global_y+1)%16)*16 + ((global_x-1+16)%16)] ||
                                    |changed_cells[((global_y+1)%16)*16 + global_x] ||
                                    |changed_cells[((global_y+1)%16)*16 + ((global_x+1)%16)]) begin
                                    
                                    inter_count <= 0;
                                    // Check 12 possible neighbors from adjacent blocks
                                    for (int dx = -1; dx <= 1; dx = dx + 1) begin
                                        for (int dy = -1; dy <= 1; dy = dy + 1) begin
                                            if (dx == 0 && dy == 0) continue;
                                            if (i + dx < 0 || i + dx >= 4 || j + dy < 0 || j + dy >= 4) begin
                                                // Neighbor is in adjacent block
                                                localparam adj_bx = (dx == -1 && i == 0) ? left_block : 
                                                                   (dx == 1 && i == 3) ? right_block : bx;
                                                localparam adj_by = (dy == -1 && j == 0) ? top_block : 
                                                                   (dy == 1 && j == 3) ? bottom_block : by;
                                                localparam adj_i = (i + dx + 4) % 4;
                                                localparam adj_j = (j + dy + 4) % 4;
                                                localparam adj_idx = (adj_by*4 + adj_j)*16 + (adj_bx*4 + adj_i);
                                                
                                                if (q[adj_idx]) inter_count <= inter_count + 1;
                                            end
                                        end
                                    end
                                    neighbor_count <= intra_count + inter_count;
                                end
                            end
                        end
                        
                        // Update rule
                        always @(posedge clk) begin
                            if (load) begin
                                q[cell_idx] <= data[cell_idx];
                            end else if (changed_cells[cell_idx] || 
                                         |changed_cells[((global_y-1+16)%16)*16 + ((global_x-1+16)%16)] ||
                                         |changed_cells[((global_y-1+16)%16)*16 + global_x] ||
                                         |changed_cells[((global_y-1+16)%16)*16 + ((global_x+1)%16)] ||
                                         |changed_cells[global_y*16 + ((global_x-1+16)%16)] ||
                                         |changed_cells[global_y*16 + ((global_x+1)%16)] ||
                                         |changed_cells[((global_y+1)%16)*16 + ((global_x-1+16)%16)] ||
                                         |changed_cells[((global_y+1)%16)*16 + global_x] ||
                                         |changed_cells[((global_y+1)%16)*16 + ((global_x+1)%16)]) begin
                                case (neighbor_count)
                                    2: q[cell_idx] <= q[cell_idx];
                                    3: q[cell_idx] <= 1'b1;
                                    default: q[cell_idx] <= 1'b0;
                                endcase
                            end
                        end
                    end
                end
            end
        end
    endgenerate

endmodule