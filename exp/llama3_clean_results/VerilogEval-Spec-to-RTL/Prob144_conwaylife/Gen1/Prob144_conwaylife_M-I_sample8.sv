module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;
reg [2:0] alive_neighbors;
reg [4:0] neighbor_x, neighbor_y;
reg [7:0] index;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        next_q = q;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        neighbor_x = (i + x + 16) % 16;
                        neighbor_y = (j + y + 16) % 16;
                        index = neighbor_x * 16 + neighbor_y;
                        alive_neighbors += q[index];
                    end
                end
                index = i * 16 + j;
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_q[index] = 0;
                end else if (alive_neighbors == 3) begin
                    next_q[index] = 1;
                end else begin
                    next_q[index] = q[index]; // No change if 2 neighbors
                end
            end
        end
        q <= next_q;
    end
end

endmodule