module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Current state storage
    reg [15:0] grid [0:15];
    
    // Next state computation
    always @(*) begin
        for (integer i = 0; i < 16; i = i+1) begin
            for (integer j = 0; j < 16; j = j+1) begin
                // Count live neighbors with toroidal wrapping
                integer count = 0;
                for (integer di = -1; di <= 1; di = di+1) begin
                    for (integer dj = -1; dj <= 1; dj = dj+1) begin
                        if (di == 0 && dj == 0) continue; // Skip self
                        integer ni = (i + di + 16) % 16;
                        integer nj = (j + dj + 16) % 16;
                        count = count + grid[ni][nj];
                    end
                end
                
                // Next state rules
                case (count)
                    2: q[i*16 + j] = grid[i][j]; // Stay same
                    3: q[i*16 + j] = 1;          // Birth/survival
                    default: q[i*16 + j] = 0;     // Death
                endcase
            end
        end
    end

    // Update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            // Load initial data
            for (integer i = 0; i < 16; i = i+1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            // Update all cells
            for (integer i = 0; i < 16; i = i+1) begin
                grid[i] <= q[i*16 +: 16];
            end
        end
    end

endmodule