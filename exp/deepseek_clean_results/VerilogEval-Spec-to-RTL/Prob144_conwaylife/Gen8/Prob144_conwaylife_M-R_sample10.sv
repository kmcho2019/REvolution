module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic
    reg [255:0] next_q;
    wire [3:0] neighbor_count [0:255];
    
    // Calculate neighbor counts for all cells
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                integer idx = i*16 + j;
                integer row, col;
                integer count = 0;
                
                // Check all 8 neighbors with wrap-around
                for (integer di = -1; di <= 1; di = di + 1) begin
                    for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                        if (di == 0 && dj == 0) continue; // Skip self
                        
                        // Calculate neighbor position with wrap-around
                        row = (i + di + 16) % 16;
                        col = (j + dj + 16) % 16;
                        
                        // Count live neighbors
                        count = count + q[row*16 + col];
                    end
                end
                
                neighbor_count[idx] = count;
                
                // Apply game rules
                case (neighbor_count[idx])
                    2: next_q[idx] = q[idx];  // Stay the same
                    3: next_q[idx] = 1'b1;    // Become alive
                    default: next_q[idx] = 1'b0; // Die
                endcase
            end
        end
    end

    // State update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule