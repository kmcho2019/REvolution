module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Load data into q when load is high
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Calculate next state
        for (int i = 0; i < 256; i++) begin
            // Calculate row and column indices
            int row = i / 16;
            int col = i % 16;

            // Initialize neighbor count
            int neighbors = 0;

            // Check all eight neighboring cells
            for (int dr = -1; dr <= 1; dr++) begin
                for (int dc = -1; dc <= 1; dc++) begin
                    // Skip self
                    if (dr == 0 && dc == 0) continue;

                    // Calculate neighbor row and column indices (toroidal)
                    int nr = (row + dr + 16) % 16;
                    int nc = (col + dc + 16) % 16;

                    // Calculate neighbor index
                    int ni = nr * 16 + nc;

                    // Increment neighbor count if neighbor is alive
                    if (q[ni]) neighbors++;
                end
            end

            // Update cell state
            if (neighbors <= 1 || neighbors >= 4) begin
                q[i] <= 1'b0;
            end else if (neighbors == 2) begin
                // Do nothing
            end else if (neighbors == 3) begin
                q[i] <= 1'b1;
            end
        end
    end
end

endmodule