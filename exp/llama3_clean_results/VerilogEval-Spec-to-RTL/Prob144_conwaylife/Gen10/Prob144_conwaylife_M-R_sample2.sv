module AliveNeighborsCounter(
    input [255:0] grid,
    input [3:0] x,
    input [3:0] y,
    output reg next_state
);

always @(*) begin
    reg [3:0] alive_neighbors;
    alive_neighbors = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            int index_x = (x + i + 16) % 16;
            int index_y = (y + j + 16) % 16;
            int index = index_x + index_y * 16;
            alive_neighbors += grid[index];
        end
    end
    case (alive_neighbors)
        0, 1: next_state = 0;
        2: next_state = grid[x + y * 16];
        3: next_state = 1;
        default: next_state = 0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                reg next_state;
                AliveNeighborsCounter counter(
                   .grid(grid),
                   .x(i),
                   .y(j),
                   .next_state(next_state)
                );
                next_grid[i * 16 + j] <= next_state;
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule