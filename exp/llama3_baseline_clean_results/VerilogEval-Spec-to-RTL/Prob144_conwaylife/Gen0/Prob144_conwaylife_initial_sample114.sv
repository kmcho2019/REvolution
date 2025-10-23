module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Initialize the grid with the loaded data
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update the grid based on the game rules
            for (int i = 0; i < 16; i++) begin
                for (int j = 0; j < 16; j++) begin
                    int alive_neighbors = 0;
                    for (int x = -1; x <= 1; x++) begin
                        for (int y = -1; y <= 1; y++) begin
                            if (x == 0 && y == 0) begin
                                // Skip the cell itself
                                continue;
                            end
                            int nx = (i + x + 16) % 16;
                            int ny = (j + y + 16) % 16;
                            if (q[nx*16 + ny]) begin
                                alive_neighbors++;
                            end
                        end
                    end
                    if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                        q[i*16 + j] <= 0;
                    end else if (alive_neighbors == 3) begin
                        q[i*16 + j] <= 1;
                    end else begin
                        // 2 neighbors: Cell state does not change
                        // Do nothing
                    end
                end
            end
        end
    end

endmodule