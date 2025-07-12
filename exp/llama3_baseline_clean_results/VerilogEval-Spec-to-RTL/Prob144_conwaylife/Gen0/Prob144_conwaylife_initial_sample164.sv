module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to count the number of alive neighbors for a cell
function integer count_neighbors;
    input [255:0] grid;
    input [7:0] x;
    input [7:0] y;
    integer neighbors;
    begin
        neighbors = 0;
        for (integer i = -1; i <= 1; i = i + 1) begin
            for (integer j = -1; j <= 1; j = j + 1) begin
                if (i == 0 && j == 0) begin
                    continue;
                end
                integer nx, ny;
                nx = (x + i) % 16;
                ny = (y + j) % 16;
                if (grid[nx + (ny * 16)] == 1'b1) begin
                    neighbors = neighbors + 1;
                end
            end
        end
        count_neighbors = neighbors;
    end
endfunction

// Function to get the next state of a cell
function integer get_next_state;
    input [255:0] grid;
    input [7:0] x;
    input [7:0] y;
    integer next_state;
    integer neighbors;
    begin
        neighbors = count_neighbors(grid, x, y);
        if (neighbors < 2 || neighbors > 3) begin
            next_state = 0;
        end else if (neighbors == 3) begin
            next_state = 1;
        end else begin
            next_state = grid[x + (y * 16)];
        end
        get_next_state = next_state;
    end
endfunction

// Load the initial state into the grid
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                integer x, y, index;
                x = i;
                y = j;
                index = x + (y * 16);
                q[index] <= get_next_state(q, x, y);
            end
        end
    end
end

endmodule