module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    // Shared row calculations
    wire [15:0] row_prev [15:0];
    wire [15:0] row_next [15:0];
    generate
        for (genvar r = 0; r < 16; r = r + 1) begin : row_wrap
            assign row_prev[r] = q[((r+15)%16)*16 +: 16];
            assign row_next[r] = q[((r+1)%16)*16 +: 16];
        end
    endgenerate

    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_gen
            // Current row
            wire [15:0] current_row = q[row*16 +: 16];
            
            for (col = 0; col < 16; col = col + 1) begin : col_gen
                localparam idx = row*16 + col;
                
                // Column wrap using bit masking (optimized)
                wire [3:0] c_prev = (col + 15) & 4'b1111;
                wire [3:0] c_next = (col + 1) & 4'b1111;
                
                // Neighbor selection
                wire [2:0] top_neighbors = {
                    row_prev[row][c_prev],
                    row_prev[row][col],
                    row_prev[row][c_next]
                };
                
                wire [1:0] mid_neighbors = {
                    current_row[c_prev],
                    current_row[c_next]
                };
                
                wire [2:0] bot_neighbors = {
                    row_next[row][c_prev],
                    row_next[row][col],
                    row_next[row][c_next]
                };
                
                // Carry-save addition (3 + 2 + 3 bits)
                wire [3:0] sum1 = {1'b0, top_neighbors} + {1'b0, mid_neighbors};
                wire [3:0] neighbor_count = sum1 + {1'b0, bot_neighbors};
                
                // Next state logic (optimized)
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                    (neighbor_count == 2) ? q[idx] :
                                    1'b0;
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Unconditional update (simpler timing path)
            q <= next_q;
        end
    end

endmodule