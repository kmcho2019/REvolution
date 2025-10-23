module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_state;

// Function to count the number of alive neighbors for a cell
function [3:0] count_neighbors;
    input [255:0] state;
    input [7:0] row;
    input [7:0] col;
    reg [3:0] neighbors;

    // Calculate the row and column indices of the neighbors
    wire [7:0] row_n = row - 1;
    wire [7:0] row_p = row + 1;
    wire [7:0] col_n = col - 1;
    wire [7:0] col_p = col + 1;

    // Handle wrap-around cases
    assign row_n = row_n == 8'd255 ? 8'd0 : row_n;
    assign row_p = row_p == 8'd16 ? 8'd0 : row_p;
    assign col_n = col_n == 8'd255 ? 8'd0 : col_n;
    assign col_p = col_p == 8'd16 ? 8'd0 : col_p;

    // Count the number of alive neighbors
    assign neighbors = state[{row_n, col_n}] + state[{row_n, col}] + state[{row_n, col_p}] +
                       state[{row, col_n}] + state[{row, col_p}] +
                       state[{row_p, col_n}] + state[{row_p, col}] + state[{row_p, col_p}];

    // Return the count of alive neighbors
    count_neighbors = neighbors;
endfunction

// Update the state of each cell based on the number of its alive neighbors
always @(*) begin
    for (int row = 0; row < 16; row++) begin
        for (int col = 0; col < 16; col++) begin
            reg [3:0] neighbors;
            assign neighbors = count_neighbors(q, row, col);

            // Apply the rules of the game
            if (neighbors <= 1 || neighbors >= 4) begin
                next_state[{row, col}] = 1'b0;
            end else if (neighbors == 2) begin
                next_state[{row, col}] = q[{row, col}];
            end else if (neighbors == 3) begin
                next_state[{row, col}] = 1'b1;
            end
        end
    end
end

// Update the current state at each clock cycle
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

endmodule