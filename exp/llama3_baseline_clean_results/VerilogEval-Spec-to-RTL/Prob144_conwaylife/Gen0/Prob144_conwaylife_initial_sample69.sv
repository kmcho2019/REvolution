module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [255:0] next_q;
        for (int i = 0; i < 256; i++) begin
            int x = i % 16;
            int y = i / 16;
            reg [7:0] neighbors;
            neighbors = 0;
            // check all 8 neighbors
            for (int dx = -1; dx <= 1; dx++) begin
                for (int dy = -1; dy <= 1; dy++) begin
                    if (dx == 0 && dy == 0) continue; // skip the cell itself
                    int nx = (x + dx + 16) % 16;
                    int ny = (y + dy + 16) % 16;
                    int neighbor_index = ny * 16 + nx;
                    neighbors += q[neighbor_index];
                end
            end
            // update the cell's state
            if (neighbors <= 1 || neighbors >= 4) begin
                next_q[i] <= 0;
            end else if (neighbors == 2) begin
                next_q[i] <= q[i];
            end else if (neighbors == 3) begin
                next_q[i] <= 1;
            end
        end
        q <= next_q;
    end
end

endmodule