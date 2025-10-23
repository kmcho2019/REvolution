module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Extended grid with wrapped borders (18x18)
    reg [323:0] extended_grid;  // 18*18=324 bits
    
    // Create extended grid with wrapped borders
    always @(*) begin
        // Center 16x16 grid
        extended_grid[17*18 + 17 +:256] = q;
        
        // Wrap top and bottom borders
        for (integer i = 0; i < 16; i = i + 1) begin
            // Top border (row -1)
            extended_grid[0*18 + 1 + i] = q[15*16 + i];
            // Bottom border (row 16)
            extended_grid[17*18 + 1 + i] = q[0*16 + i];
        end
        
        // Wrap left and right borders
        for (integer i = 0; i < 18; i = i + 1) begin
            // Left border (column -1)
            extended_grid[i*18 + 0] = extended_grid[i*18 + 16];
            // Right border (column 16)
            extended_grid[i*18 + 17] = extended_grid[i*18 + 1];
        end
    end

    // Next state computation
    wire [255:0] next_q;
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Get 3x3 neighborhood from extended grid
                wire [8:0] neighborhood;
                assign neighborhood[0] = extended_grid[(i)*18 + (j)];     // top-left
                assign neighborhood[1] = extended_grid[(i)*18 + (j+1)];   // top
                assign neighborhood[2] = extended_grid[(i)*18 + (j+2)];   // top-right
                assign neighborhood[3] = extended_grid[(i+1)*18 + (j)];   // left
                assign neighborhood[4] = extended_grid[(i+1)*18 + (j+1)]; // center
                assign neighborhood[5] = extended_grid[(i+1)*18 + (j+2)]; // right
                assign neighborhood[6] = extended_grid[(i+2)*18 + (j)];   // bottom-left
                assign neighborhood[7] = extended_grid[(i+2)*18 + (j+1)]; // bottom
                assign neighborhood[8] = extended_grid[(i+2)*18 + (j+2)]; // bottom-right
                
                // Count neighbors (excluding center cell)
                wire [3:0] neighbor_count;
                assign neighbor_count = neighborhood[0] + neighborhood[1] + neighborhood[2] +
                                      neighborhood[3] + neighborhood[5] +
                                      neighborhood[6] + neighborhood[7] + neighborhood[8];
                
                // Apply game rules
                assign next_q[i*16 + j] = (neighbor_count == 3) ? 1'b1 :
                                        (neighbor_count == 2) ? q[i*16 + j] :
                                        1'b0;
            end
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule