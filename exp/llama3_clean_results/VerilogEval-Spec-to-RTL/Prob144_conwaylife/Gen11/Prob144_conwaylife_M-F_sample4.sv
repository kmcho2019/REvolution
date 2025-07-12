module AliveNeighborsCounter(
    input [255:0] grid,
    input [3:0] x,
    input [3:0] y,
    output reg next_state
);

    reg [3:0] alive_neighbors;
    assign alive_neighbors = 
        grid[((x - 1 + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x - 1 + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x - 1 + 16) % 16) + ((y + 1 + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y + 1 + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y + 1 + 16) % 16) * 16];

    always @(*) begin
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
        for (i = 0; i < 256; i++) begin
            reg [3:0] x = i % 16;
            reg [3:0] y = i / 16;
            reg next_state;
            AliveNeighborsCounter counter(
               .grid(grid),
               .x(x),
               .y(y),
               .next_state(next_state)
            );
            next_grid[i] <= next_state;
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule