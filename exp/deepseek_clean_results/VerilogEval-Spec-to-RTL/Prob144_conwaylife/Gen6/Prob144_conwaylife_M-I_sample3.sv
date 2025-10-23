module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] neighbor_counts [0:15];  // Row-wise neighbor counts
    
    // Stability flags (row-based to reduce area)
    wire [15:0] row_stable;
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            // Shared row calculations
            wire [15:0] row_above = q[{(row-4'b1)&15, 4'b0}+:16];
            wire [15:0] row_current = q[{row, 4'b0}+:16];
            wire [15:0] row_below = q[{(row+4'b1)&15, 4'b0}+:16];
            
            // Stage 1: Calculate row sums
            reg [15:0] row_sums [2:0];  // Top, middle, bottom
            always @(*) begin
                // Left/right neighbors with wrap-around
                row_sums[0] = {row_above[0], row_above[15:1]} + row_above + {row_above[14:0], row_above[15]};
                row_sums[1] = {row_current[0], row_current[15:1]} + {row_current[14:0], row_current[15]};
                row_sums[2] = {row_below[0], row_below[15:1]} + row_below + {row_below[14:0], row_below[15]};
            end
            
            // Stage 2: Column sums (registered for pipelining)
            always @(posedge clk) begin
                for (col = 0; col < 16; col = col + 1) begin
                    neighbor_counts[row][col] <= row_sums[0][col] + row_sums[1][col] + row_sums[2][col];
                end
            end
            
            // Stability detection (per row)
            assign row_stable[row] = &(neighbor_counts[row] == {16{2'b10}});
        end
    endgenerate

    // Clock gating logic
    wire update_en = ~load & ~(&row_stable);
    
    // Next state calculation
    always @(posedge clk) begin
        q_ff <= q;  // Pipeline register
        
        if (load) begin
            q <= data;
        end else if (update_en) begin
            for (integer row = 0; row < 16; row = row + 1) begin
                if (!row_stable[row]) begin
                    for (integer col = 0; col < 16; col = col + 1) begin
                        case (neighbor_counts[row][col])
                            4'd3: q[row*16 + col] <= 1'b1;
                            4'd2: q[row*16 + col] <= q_ff[row*16 + col];
                            default: q[row*16 + col] <= 1'b0;
                        endcase
                    end
                end
            end
        end
    end

endmodule