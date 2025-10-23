module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    // Pre-calculate row offsets for neighbor access
    wire [3:0] row_offsets [0:2];
    assign row_offsets[0] = 4'b1111; // row-1
    assign row_offsets[1] = 4'b0000; // current row
    assign row_offsets[2] = 4'b0001; // row+1
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with shared offsets
                wire [3:0] col_prev = col - 4'b1;
                wire [3:0] col_next = col + 4'b1;
                
                // Get neighbor cells using parallel lookups
                wire [7:0] neighbors;
                assign neighbors[0] = q[{(row_offsets[0] + row[3:0]), col_prev[3:0]}];
                assign neighbors[1] = q[{(row_offsets[0] + row[3:0]), col[3:0]}];
                assign neighbors[2] = q[{(row_offsets[0] + row[3:0]), col_next[3:0]}];
                assign neighbors[3] = q[{(row_offsets[1] + row[3:0]), col_prev[3:0]}];
                assign neighbors[4] = q[{(row_offsets[1] + row[3:0]), col_next[3:0]}];
                assign neighbors[5] = q[{(row_offsets[2] + row[3:0]), col_prev[3:0]}];
                assign neighbors[6] = q[{(row_offsets[2] + row[3:0]), col[3:0]}];
                assign neighbors[7] = q[{(row_offsets[2] + row[3:0]), col_next[3:0]}];
                
                // Parallel counter for neighbor count (more efficient than adder chain)
                wire [3:0] neighbor_count;
                assign neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                                      neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
                
                // Stability detection with optimized encoding
                assign cell_stable[row*16 + col] = (neighbor_count == 4'd2) & ~load;
                
                // Next state calculation with immediate neighbor calculation gating
                wire cell_active = !cell_stable[row*16 + col] | load;
                assign next_q[row*16 + col] = cell_active ? 
                    ((neighbor_count == 4'd3) ? 1'b1 :
                     (neighbor_count == 4'd2) ? q[row*16 + col] :
                     1'b0) : q[row*16 + col];
            end
        end
    endgenerate

    // Optimized sequential update with enhanced clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that need to change
            q <= next_q;
        end
    end

endmodule