module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Calculate next state of each cell
reg [255:0] next_q;

always @(*) begin
    next_q = 256'b0;
    for (int i = 0; i < 256; i++) begin
        // Calculate row and column indices
        int row = i / 16;
        int col = i % 16;

        // Count neighbors
        int neighbors = 0;
        for (int dr = -1; dr <= 1; dr++) begin
            for (int dc = -1; dc <= 1; dc++) begin
                if (dr == 0 && dc == 0) continue; // Skip current cell

                int nr = (row + dr + 16) % 16;
                int nc = (col + dc + 16) % 16;
                int ni = nr * 16 + nc;

                if (q[ni]) neighbors++;
            end
        end

        // Calculate next state
        if (load) begin
            next_q[i] = data[i];
        end else if (neighbors == 2) begin
            next_q[i] = q[i];
        end else if (neighbors == 3) begin
            next_q[i] = 1'b1;
        end else begin
            next_q[i] = 1'b0;
        end
    end
end

// Update current state at positive clock edge
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule