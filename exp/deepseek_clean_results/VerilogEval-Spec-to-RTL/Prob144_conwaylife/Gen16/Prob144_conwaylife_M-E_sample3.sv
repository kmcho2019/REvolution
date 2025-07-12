module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid is divided into 16 4x4 blocks (indexed 0-15)
    // Each block processes its 16 cells plus surrounding border cells
    wire [16*16-1:0] next_q;
    reg [255:0] q_ff;

    // Pipeline registers
    reg [255:0] q_stage1;
    reg [16*16-1:0] neighbor_counts [0:15];

    // Pre-compute wrapped indices for each block
    function [3:0] wrap(input [3:0] idx);
        wrap = (idx == 4'd15) ? 4'd0 : (idx + 1);
    endfunction

    function [3:0] unwrap(input [3:0] idx);
        unwrap = (idx == 4'd0) ? 4'd15 : (idx - 1);
    endfunction

    // Stage 1: Capture current state and prepare neighbor counts
    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
            q_stage1 <= data;
        end else begin
            q_stage1 <= q_ff;
        end
    end

    // Generate logic for each 4x4 block
    genvar block;
    generate
        for (block = 0; block < 16; block = block + 1) begin : block_logic
            // Block coordinates (bx, by)
            localparam bx = block / 4;
            localparam by = block % 4;
            
            // Expanded block area (6x6) including borders
            wire [35:0] block_neighbors;
            
            // Get all 36 neighbor cells (6x6) for this block
            // Using pre-computed wrapped indices
            integer i, j;
            always @(*) begin
                for (i = 0; i < 6; i = i + 1) begin
                    for (j = 0; j < 6; j = j + 1) begin
                        // Calculate wrapped global coordinates
                        reg [3:0] gx, gy;
                        gx = (bx == 0 && i < 1) ? 4'd15 : 
                             (bx == 3 && i > 4) ? 4'd0 : 
                             (bx*4 + i - 1);
                        gy = (by == 0 && j < 1) ? 4'd15 : 
                             (by == 3 && j > 4) ? 4'd0 : 
                             (by*4 + j - 1);
                        block_neighbors[i*6 + j] = q_stage1[gx*16 + gy];
                    end
                end
            end

            // Stage 2: Count neighbors for each cell in block
            integer cell;
            always @(posedge clk) begin
                for (cell = 0; cell < 16; cell = cell + 1) begin
                    // Cell coordinates within block (cx, cy)
                    reg [1:0] cx = cell / 4;
                    reg [1:0] cy = cell % 4;
                    
                    // Get 8 neighbors from the 6x6 block_neighbors
                    reg [7:0] neighbors;
                    neighbors[0] = block_neighbors[(cx+0)*6 + (cy+0)]; // NW
                    neighbors[1] = block_neighbors[(cx+0)*6 + (cy+1)]; // N
                    neighbors[2] = block_neighbors[(cx+0)*6 + (cy+2)]; // NE
                    neighbors[3] = block_neighbors[(cx+1)*6 + (cy+0)]; // W
                    neighbors[4] = block_neighbors[(cx+1)*6 + (cy+2)]; // E
                    neighbors[5] = block_neighbors[(cx+2)*6 + (cy+0)]; // SW
                    neighbors[6] = block_neighbors[(cx+2)*6 + (cy+1)]; // S
                    neighbors[7] = block_neighbors[(cx+2)*6 + (cy+2)]; // SE
                    
                    // Optimized neighbor counting
                    neighbor_counts[block][cell] = neighbors[0] + neighbors[1] + neighbors[2] + 
                                                 neighbors[3] + neighbors[4] + 
                                                 neighbors[5] + neighbors[6] + neighbors[7];
                end
            end

            // Stage 3: Calculate next state (combinational)
            for (cell = 0; cell < 16; cell = cell + 1) begin : cell_logic
                // Global cell index
                localparam gidx = (bx*4 + cell/4)*16 + (by*4 + cell%4);
                
                // Next state logic
                assign next_q[gidx] = (neighbor_counts[block][cell] == 3) ? 1'b1 :
                                    ((neighbor_counts[block][cell] == 2) ? q_ff[gidx] :
                                    1'b0;
            end
        end
    endgenerate

    // Final update stage
    always @(posedge clk) begin
        if (!load) begin
            q_ff <= next_q;
            q <= next_q;
        end
    end

endmodule