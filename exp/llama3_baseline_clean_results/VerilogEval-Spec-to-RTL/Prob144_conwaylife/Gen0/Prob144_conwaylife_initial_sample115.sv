module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Initialize grid state
integer i, j;
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Update grid state
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                // Calculate neighbor counts
                integer alive_neighbors = 0;
                integer x, y;
                for (x = -1; x <= 1; x++) begin
                    for (y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        integer neighbor_x = (i + x + 16) % 16;
                        integer neighbor_y = (j + y + 16) % 16;
                        if (q[neighbor_x * 16 + neighbor_y]) begin
                            alive_neighbors++;
                        end
                    end
                end

                // Apply game rules
                if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                    q[i * 16 + j] <= 1'b0;
                end else if (alive_neighbors == 2) begin
                    // No change
                end else if (alive_neighbors == 3) begin
                    q[i * 16 + j] <= 1'b1;
                end
            end
        end
    end
end

endmodule