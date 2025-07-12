module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to calculate the number of alive neighbors for a cell
function [2:0] count_alive_neighbors;
    input [255:0] state;
    input [3:0] x, y;
    reg [2:0] count;
    reg [3:0] i, j;
    reg [3:0] neighbor_x, neighbor_y;

    count = 0;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            neighbor_x = (x + i + 16) % 16;
            neighbor_y = (y + j + 16) % 16;
            count = count + state[neighbor_x * 16 + neighbor_y];
        end
    end
    count_alive_neighbors = count;
endfunction

// Generate next state for each cell
genvar i, j;
generate
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            wire [2:0] alive_neighbors = count_alive_neighbors(q, i, j);
            reg next_cell_state;

            always @(posedge clk) begin
                if (load) begin
                    q[i * 16 + j] <= data[i * 16 + j];
                end else begin
                    if (alive_neighbors < 2 || alive_neighbors > 3) begin
                        q[i * 16 + j] <= 0;
                    end else if (alive_neighbors == 3) begin
                        q[i * 16 + j] <= 1;
                    end else begin
                        q[i * 16 + j] <= q[i * 16 + j];
                    end
                end
            end
        end
    end
endgenerate

endmodule