module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;  // Indicates cells that won't change
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with bit masking
                wire [3:0] row_p1 = (row + 4'd1);
                wire [3:0] row_m1 = (row - 4'd1);
                wire [3:0] col_p1 = (col + 4'd1);
                wire [3:0] col_m1 = (col - 4'd1);
                
                // Get all 8 neighbors with wrap-around
                wire [7:0] neighbors = {
                    q[{row_p1[3:0], col_p1[3:0]}],  // SE
                    q[{row_p1[3:0], col[3:0]}],     // S
                    q[{row_p1[3:0], col_m1[3:0]}],  // SW
                    q[{row[3:0], col_p1[3:0]}],    // E
                    q[{row[3:0], col_m1[3:0]}],     // W
                    q[{row_m1[3:0], col_p1[3:0]}],  // NE
                    q[{row_m1[3:0], col[3:0]}],    // N
                    q[{row_m1[3:0], col_m1[3:0]}]  // NW
                };
                
                // Hierarchical neighbor counting
                wire [1:0] sum_top = neighbors[7] + neighbors[6] + neighbors[5];
                wire [1:0] sum_mid = neighbors[4] + neighbors[3];
                wire [1:0] sum_bot = neighbors[2] + neighbors[1] + neighbors[0];
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Current cell state
                wire current_cell = q[{row[3:0], col[3:0]}];
                
                // Stability detection
                assign cell_stable[row*16 + col] = (neighbor_count == 4'd2) & current_cell;
                
                // Next state logic
                assign next_q[row*16 + col] = (neighbor_count == 4'd3) ? 1'b1 :
                                             (neighbor_count == 4'd2) ? current_cell :
                                             1'b0;
            end
        end
    endgenerate

    // Optimized sequential update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update cells that will change state
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule