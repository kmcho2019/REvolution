module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Define processing element (PE) for 4x4 blocks
    genvar block_row, block_col;
    generate
        for (block_row = 0; block_row < 4; block_row = block_row + 1) begin : block_row_loop
            for (block_col = 0; block_col < 4; block_col = block_col + 1) begin : block_col_loop
                // Local storage for the 4x4 block (16 bits)
                reg [15:0] block_state;
                
                // Boundary registers for systolic communication
                reg [3:0] north_boundary, south_boundary;
                reg [3:0] west_boundary, east_boundary;
                reg [3:0] corner_regs [0:3]; // NE, NW, SE, SW
                
                // Phase control (0=internal, 1=boundary)
                reg phase;
                
                // Neighbor counts for internal cells (computed in phase 0)
                reg [3:0] internal_counts [0:15];
                
                // Next state computation
                always @(posedge clk) begin
                    if (load) begin
                        // Load initial state for this block
                        block_state <= data[block_row*64 + block_col*16 +: 16];
                        phase <= 0;
                    end else begin
                        if (phase == 0) begin
                            // Phase 0: Compute internal cells (2x2 center of 4x4 block)
                            for (integer i = 1; i <= 2; i = i + 1) begin
                                for (integer j = 1; j <= 2; j = j + 1) begin
                                    // Compute neighbor count for cell (i,j)
                                    // Uses only internal neighbors (no boundary dependencies)
                                    reg [3:0] count = 0;
                                    for (integer di = -1; di <= 1; di = di + 1) begin
                                        for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                                            if (di != 0 || dj != 0) begin
                                                count = count + block_state[(i+di)*4 + (j+dj)];
                                            end
                                        end
                                    end
                                    internal_counts[i*4 + j] <= count;
                                end
                            end
                            phase <= 1;
                        end else begin
                            // Phase 1: Compute boundary cells using propagated info
                            // Update all cells in the block
                            for (integer i = 0; i < 4; i = i + 1) begin
                                for (integer j = 0; j < 4; j = j + 1) begin
                                    if (!(i >= 1 && i <= 2 && j >= 1 && j <= 2)) begin
                                        // Boundary cell - use systolic data
                                        reg [3:0] count = 0;
                                        // Add contributions from adjacent blocks
                                        // (Implementation depends on systolic connections)
                                        // ...
                                    end
                                    
                                    // Apply game rules
                                    reg [3:0] cnt = (i >= 1 && i <= 2 && j >= 1 && j <= 2) ? 
                                                   internal_counts[i*4 + j] : count;
                                    case (cnt)
                                        2: ; // No change
                                        3: block_state[i*4 + j] <= 1'b1;
                                        default: block_state[i*4 + j] <= 1'b0;
                                    endcase
                                end
                            end
                            phase <= 0;
                            
                            // Propagate boundaries to adjacent PEs
                            // ...
                        end
                    end
                end
                
                // Assign output for this block
                always @(*) begin
                    q[block_row*64 + block_col*16 +: 16] = block_state;
                end
            end
        end
    endgenerate

endmodule