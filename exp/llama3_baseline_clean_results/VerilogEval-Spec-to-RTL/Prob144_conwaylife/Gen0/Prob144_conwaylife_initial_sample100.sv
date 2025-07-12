module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

// Function to count the number of alive neighbors for a given cell
function [3:0] count_neighbors;
    input [15:0] row;
    input [15:0] col;
    reg [3:0] count;
    reg [15:0] row_up, row_down, col_left, col_right;

    begin
        count = 0;
        row_up = (row == 0) ? 15 : row - 1;
        row_down = (row == 15) ? 0 : row + 1;
        col_left = (col == 0) ? 15 : col - 1;
        col_right = (col == 15) ? 0 : col + 1;

        count += q_reg[(row_up * 16) + col];
        count += q_reg[(row_up * 16) + col_right];
        count += q_reg[(row * 16) + col_right];
        count += q_reg[(row_down * 16) + col_right];
        count += q_reg[(row_down * 16) + col];
        count += q_reg[(row_down * 16) + col_left];
        count += q_reg[(row * 16) + col_left];
        count += q_reg[(row_up * 16) + col_left];

        count_neighbors = count;
    end
endfunction

// Combinational logic for updating the grid state
reg [255:0] next_state;
always @(*) begin
    for (int row = 0; row < 16; row++) begin
        for (int col = 0; col < 16; col++) begin
            reg [3:0] neighbors;
            neighbors = count_neighbors(row, col);
            case (neighbors)
                0, 1: next_state[(row * 16) + col] = 0;
                2: next_state[(row * 16) + col] = q_reg[(row * 16) + col];
                3: next_state[(row * 16) + col] = 1;
                default: next_state[(row * 16) + col] = 0;
            endcase
        end
    end
end

// Sequential logic for loading the initial state and updating the grid state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule