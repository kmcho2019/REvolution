module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_q;
    reg [255:0] neighbor_counts [0:1]; // Two-stage pipeline

    // Shared adder block
    function [3:0] count_neighbors;
        input [7:0] neighbors;
        begin
            count_neighbors = neighbors[0] + neighbors[1] + neighbors[2] + 
                             neighbors[3] + neighbors[4] + 
                             neighbors[5] + neighbors[6] + neighbors[7];
        end
    endfunction

    // First pipeline stage: Calculate neighbor counts
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_ff <= data;
        end else begin
            q_ff <= q;
            
            // Process cells in groups of 16 for better resource sharing
            for (integer i = 0; i < 256; i = i + 1) begin
                // Calculate row and column indices
                integer row = i / 16;
                integer col = i % 16;
                
                // Calculate neighbor positions with wrap-around
                integer row_prev = (row == 0) ? 15 : (row - 1);
                integer row_next = (row == 15) ? 0 : (row + 1);
                integer col_prev = (col == 0) ? 15 : (col - 1);
                integer col_next = (col == 15) ? 0 : (col + 1);
                
                // Get neighbor values
                reg [7:0] neighbors;
                neighbors[0] = q[row_prev*16 + col_prev]; // top-left
                neighbors[1] = q[row_prev*16 + col];      // top
                neighbors[2] = q[row_prev*16 + col_next]; // top-right
                neighbors[3] = q[row*16 + col_prev];     // left
                neighbors[4] = q[row*16 + col_next];      // right
                neighbors[5] = q[row_next*16 + col_prev]; // bottom-left
                neighbors[6] = q[row_next*16 + col];      // bottom
                neighbors[7] = q[row_next*16 + col_next]; // bottom-right
                
                neighbor_counts[0][i] = count_neighbors(neighbors);
            end
        end
    end

    // Second pipeline stage: Calculate next state
    always @(posedge clk) begin
        neighbor_counts[1] <= neighbor_counts[0];
        
        for (integer i = 0; i < 256; i = i + 1) begin
            // Stability check and next state calculation
            if (neighbor_counts[0][i] == 3) begin
                next_q[i] <= 1'b1;
            end else if (neighbor_counts[0][i] == 2) begin
                next_q[i] <= q_ff[i]; // Maintain state
            end else begin
                next_q[i] <= 1'b0;
            end
        end
        
        // Final update with clock gating for stable cells
        if (!load) begin
            for (integer i = 0; i < 256; i = i + 1) begin
                // Only update if state will change
                if (next_q[i] != q[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule