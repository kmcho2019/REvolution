module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer row, col, idx;
    integer neighbor_row, neighbor_col, neighbor_idx;
    integer neighbor_count;

    // Compute next state for each cell
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            // Current cell's row and column
            localparam row = i / 16;
            localparam col = i % 16;
            
            // Count live neighbors
            integer count;
            initial count = 0;
            
            always @(*) begin
                count = 0;
                // Check all 8 neighbors with wrap-around
                for (integer dr = -1; dr <= 1; dr = dr + 1) begin
                    for (integer dc = -1; dc <= 1; dc = dc + 1) begin
                        if (dr == 0 && dc == 0) continue; // skip self
                        
                        // Calculate neighbor coordinates with wrap-around
                        neighbor_row = (row + dr + 16) % 16;
                        neighbor_col = (col + dc + 16) % 16;
                        neighbor_idx = neighbor_row * 16 + neighbor_col;
                        
                        // Add to count if neighbor is alive
                        count = count + q[neighbor_idx];
                    end
                end
                
                // Apply transition rules
                case (count)
                    0, 1: next_q[i] = 1'b0;    // 0-1 neighbors: die
                    2:    next_q[i] = q[i];     // 2 neighbors: stay same
                    3:    next_q[i] = 1'b1;     // 3 neighbors: live/born
                    default: next_q[i] = 1'b0;   // 4+ neighbors: die
                endcase
            end
        end
    endgenerate

    // Update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Load initial state
        end else begin
            q <= next_q; // Update to next state
        end
    end

endmodule