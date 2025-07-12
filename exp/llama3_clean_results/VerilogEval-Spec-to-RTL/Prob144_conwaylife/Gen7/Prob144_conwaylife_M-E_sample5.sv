// NeighbourCounter module
module NeighbourCounter(
    input [255:0] grid,
    input [7:0] row,
    input [7:0] col,
    output reg [3:0] count
);

integer i, j, new_row, new_col;

always @(grid or row or col) begin
    count = 0;
    for (i = -1; i <= 1; i++) begin
        for (j = -1; j <= 1; j++) begin
            if ((i == 0) && (j == 0)) begin
                continue;
            end
            new_row = (row + i + 16) % 16;
            new_col = (col + j + 16) % 16;
            if (grid[new_row * 16 + new_col]) begin
                count = count + 1;
            end
        end
    end
end

endmodule

// GameLogic module
module GameLogic(
    input curr_state,
    input [3:0] count,
    output reg next_state
);

always @(curr_state or count) begin
    case (count)
        0, 1: next_state = 1'b0;
        2: next_state = curr_state;
        3: next_state = 1'b1;
        default: next_state = 1'b0;
    endcase
end

endmodule

// TopModule
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
integer row, col;

// Instantiate NeighbourCounter and GameLogic modules for each cell
NeighbourCounter neighbour_counter[15:0][15:0] (
    .grid(grid),
    .row({4'b0, row}),
    .col({4'b0, col}),
    .count()
);

GameLogic game_logic[15:0][15:0] (
    .curr_state(grid[row * 16 + col]),
    .count(neighbour_counter[row][col].count),
    .next_state()
);

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (row = 0; row < 16; row++) begin
            for (col = 0; col < 16; col++) begin
                grid[row * 16 + col] <= game_logic[row][col].next_state;
            end
        end
    end
    q <= grid;
end

endmodule