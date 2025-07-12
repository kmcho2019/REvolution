// Module to calculate the number of alive neighbors for a cell
module AliveNeighbors(
    input [255:0] q,
    input [3:0] x,
    input [3:0] y,
    output [2:0] alive_neighbors
);

reg [2:0] alive_neighbors_reg;
reg [3:0] i, j;
reg [3:0] neighbor_x, neighbor_y;

always @(q, x, y) begin
    alive_neighbors_reg = 0;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            neighbor_x = (x + i + 16) % 16;
            neighbor_y = (y + j + 16) % 16;
            alive_neighbors_reg = alive_neighbors_reg + q[neighbor_x * 16 + neighbor_y];
        end
    end
end

assign alive_neighbors = alive_neighbors_reg;

endmodule

// Main module
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;
reg [3:0] i, j;

// Instantiate AliveNeighbors module for each cell
AliveNeighbors alive_neighbors_inst(
    .q(q),
    .x(i),
    .y(j),
    .alive_neighbors(alive_neighbors)
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        next_q = q;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
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