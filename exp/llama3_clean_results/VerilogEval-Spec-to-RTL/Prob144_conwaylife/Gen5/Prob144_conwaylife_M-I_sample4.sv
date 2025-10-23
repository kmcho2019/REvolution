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
        for (reg [3:0] i = 0; i < 16; i = i + 1) begin
            for (reg [3:0] j = 0; j < 16; j = j + 1) begin
                reg [2:0] alive_neighbors;
                alive_neighbors = 0;
                for (reg [2:0] x = -1; x <= 1; x = x + 1) begin
                    for (reg [2:0] y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) begin
                            // Skip the current cell
                        end else begin
                            reg [3:0] neighbor_x, neighbor_y;
                            neighbor_x = (i + x + 16) % 16;
                            neighbor_y = (j + y + 16) % 16;
                            reg [7:0] neighbor_index;
                            neighbor_index = {neighbor_x, neighbor_y};
                            if (q[neighbor_index[7:0]]) begin
                                alive_neighbors = alive_neighbors + 1;
                            end
                        end
                    end
                end
                reg [7:0] index;
                index = {i, j};
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_q[index[7:0]] = 0;
                end else if (alive_neighbors == 3) begin
                    next_q[index[7:0]] = 1;
                end else begin
                    next_q[index[7:0]] = q[index[7:0]]; // No change if 2 neighbors
                end
            end
        end
        q <= next_q;
    end
end

endmodule