module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to calculate the next state of a cell based on its current state and the states of its neighbors
function [15:0] get_neighbors;
    input [15:0] row;
    input [15:0] col;
    input [255:0] state;
    reg [7:0] neighbors;

    // Calculate the indices of the neighboring cells
    reg [3:0] row_n, row_s, row_e, row_w;
    reg [3:0] col_n, col_s, col_e, col_w;

    // Toroidal grid, so wrap around to the other side if necessary
    row_n = (row - 1) % 16;
    row_s = (row + 1) % 16;
    col_w = (col - 1) % 16;
    col_e = (col + 1) % 16;

    // Count the number of alive neighbors
    neighbors = (state[(row_n * 16 + col_e)] + state[(row_n * 16 + col)] +
                 state[(row_n * 16 + col_w)] + state[(row * 16 + col_e)] +
                 state[(row * 16 + col_w)] + state[(row_s * 16 + col_e)] +
                 state[(row_s * 16 + col)] + state[(row_s * 16 + col_w)]);

    return neighbors;
endfunction

// Function to calculate the next state of a cell
function [0:0] next_state;
    input [0:0] cell;
    input [7:0] neighbors;

    case (neighbors)
        0, 1: next_state = 0;
        2: next_state = cell;
        3: next_state = 1;
        default: next_state = 0;
    endcase
endfunction

// Combinatorial logic to calculate the next state of the game
reg [255:0] next_q;
integer i, j;
always @(*)
begin
    next_q = 0;
    for (i = 0; i < 16; i++)
    begin
        for (j = 0; j < 16; j++)
        begin
            reg [7:0] neighbors = get_neighbors(i, j, q);
            reg [0:0] cell = q[i * 16 + j];
            next_q[i * 16 + j] = next_state(cell, neighbors);
        end
    end
end

// Sequential logic to store the current state and update it on every clock cycle
always @(posedge clk)
begin
    if (load)
    begin
        q <= data;
    end
    else
    begin
        q <= next_q;
    end
end

endmodule