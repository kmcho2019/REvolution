module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

integer i, j, x, y, index, neighbor_index;
reg [2:0] alive_neighbors;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                alive_neighbors = 0;
                for (x = -1; x <= 1; x = x + 1) begin
                    for (y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        integer neighbor_x, neighbor_y;
                        neighbor_x = (i + x + 16) % 16;
                        neighbor_y = (j + y + 16) % 16;
                        neighbor_index = neighbor_x * 16 + neighbor_y;
                        if (q[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
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