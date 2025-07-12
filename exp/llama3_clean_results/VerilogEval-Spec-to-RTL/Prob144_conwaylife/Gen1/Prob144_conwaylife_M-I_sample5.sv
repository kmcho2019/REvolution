module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;
reg [2:0] alive_neighbors;
reg [3:0] i, j, x, y;
reg [3:0] neighbor_x, neighbor_y;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        next_q = q;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                alive_neighbors = 0;
                for (x = -1; x <= 1; x = x + 1) begin
                    for (y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        neighbor_x = (i + x + 16) % 16;
                        neighbor_y = (j + y + 16) % 16;
                        alive_neighbors = alive_neighbors + q[neighbor_x * 16 + neighbor_y];
                    end
                end
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_q[i * 16 + j] = 0;
                end else if (alive_neighbors == 3) begin
                    next_q[i * 16 + j] = 1;
                end else begin
                    next_q[i * 16 + j] = q[i * 16 + j];
                end
            end
        end
        q <= next_q;
    end
end

endmodule