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
                // Calculate neighbor positions with bit masking (power-of-2 optimization)
                wire [3:0] row_prev = row - 4'b1;
                wire [3:0] row_next = row + 4'b1;
                wire [3:0] col_prev = col - 4'b1;
                wire [3:0] col_next = col + 4'b1;
                
                // Get neighbor cells (using bit masking for wrap-around)
                wire n0 = q[{row_prev[3:0], col_prev[3:0]}];
                wire n1 = q[{row_prev[3:0], col[3:0]}];
                wire n2 = q[{row_prev[3:0], col_next[3:0]}];
                wire n3 = q[{row[3:0], col_prev[3:0]}];
                wire n4 = q[{row[3:0], col_next[3:0]}];
                wire n5 = q[{row_next[3:0], col_prev[3:0]}];
                wire n6 = q[{row_next[3:0], col[3:0]}];
                wire n7 = q[{row_next[3:0], col_next[3:0]}];
                
                // Carry-save neighbor counting
                wire [1:0] sum_top = n0 + n1 + n2;
                wire [1:0] sum_mid = n3 + n4;
                wire [1:0] sum_bot = n5 + n6 + n7;
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Stability detection for clock gating
                assign cell_stable[row*16 + col] = (neighbor_count == 4'd2);
                
                // Next state calculation
                assign next_q[row*16 + col] = (neighbor_count == 4'd3) ? 1'b1 :
                                             (neighbor_count == 4'd2) ? q[row*16 + col] :
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