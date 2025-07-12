module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (reg [7:0] i = 0; i < 256; i = i + 1) begin
            reg [3:0] x, y;
            x = i / 16;
            y = i % 16;

            reg [2:0] alive_neighbors;
            alive_neighbors = 0;

            for (reg [2:0] dx = -1; dx <= 1; dx = dx + 1) begin
                for (reg [2:0] dy = -1; dy <= 1; dy = dy + 1) begin
                    if (dx == 0 && dy == 0) begin
                        // Skip the current cell
                    end else begin
                        reg [3:0] nx, ny;
                        nx = (x + dx + 16) % 16;
                        ny = (y + dy + 16) % 16;
                        reg [7:0] index;
                        index = nx * 16 + ny;
                        if (q[index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end

            if (alive_neighbors < 2 || alive_neighbors > 3) begin
                next_q[i] = 0;
            end else if (alive_neighbors == 3) begin
                next_q[i] = 1;
            end else begin
                next_q[i] = q[i]; // No change if 2 neighbors
            end
        end
        q <= next_q;
    end
end

endmodule