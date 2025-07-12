module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stability detection and next state
    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    // Neighbor counting pipeline
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Calculate neighbor positions with optimized wrap-around
                wire [3:0] row_above = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_below = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_left = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_right = (j == 15) ? 0 : (j + 1);
                
                // Get all 8 neighbors
                wire [7:0] neighbors = {
                    q[row_above*16 + col_left],  // top-left
                    q[row_above*16 + j],        // top-center
                    q[row_above*16 + col_right], // top-right
                    q[i*16 + col_left],         // left
                    q[i*16 + col_right],        // right
                    q[row_below*16 + col_left],  // bottom-left
                    q[row_below*16 + j],         // bottom-center
                    q[row_below*16 + col_right]  // bottom-right
                };
                
                // Optimized neighbor counting using carry-save
                wire [1:0] sum_top = neighbors[7] + neighbors[6] + neighbors[5];
                wire [1:0] sum_mid = neighbors[4] + neighbors[3];
                wire [1:0] sum_bot = neighbors[2] + neighbors[1] + neighbors[0];
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Current cell state
                wire current = q[i*16 + j];
                
                // Stability detection
                assign cell_stable[i*16 + j] = (neighbor_count == 4'd2) & current;
                
                // Next state logic
                assign next_q[i*16 + j] = cell_stable[i*16 + j] ? current :
                                        (neighbor_count == 4'd3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Pipelined update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update cells that will change
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule