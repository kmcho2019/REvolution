module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Function to calculate the index of a cell in the grid
function [7:0] index(reg [3:0] i, reg [3:0] j);
    index = (i * 16) + j;
endfunction

// Function to calculate the index of a neighbour in the grid
function [7:0] neighbour_index(reg [3:0] i, reg [3:0] j, reg [3:0] x, reg [3:0] y);
    reg [3:0] new_i;
    reg [3:0] new_j;
    new_i = (i + x + 16) % 16;
    new_j = (j + y + 16) % 16;
    neighbour_index = (new_i * 16) + new_j;
endfunction

// Processing element
module ProcessingElement(
    input [255:0] grid,
    input [3:0] i,
    input [3:0] j,
    output reg next_state
);
    reg [3:0] count;
    count = 0;
    for (int x = -1; x <= 1; x++) begin
        for (int y = -1; y <= 1; y++) begin
            if ((x == 0) && (y == 0)) begin
                continue;
            end
            if (grid[neighbour_index(i, j, x, y)]) begin
                count = count + 1;
            end
        end
    end
    if (count <= 1 || count >= 4) begin
        next_state = 1'b0;
    end else if (count == 3) begin
        next_state = 1'b1;
    end else begin
        next_state = grid[index(i, j)];
    end
endmodule

// 2D array of processing elements
reg [255:0] next_grid;
ProcessingElement pe[15:0][15:0] (.grid(grid), .i(4'b????), .j(4'b????), .next_state(next_grid[index(4'b????, 4'b????)]));

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                pe[i][j].i = i;
                pe[i][j].j = j;
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule