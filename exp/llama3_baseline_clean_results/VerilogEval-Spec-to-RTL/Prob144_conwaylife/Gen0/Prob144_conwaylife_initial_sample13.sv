module TopModule (
    input           clk,
    input           load,
    input   [255:0] data,
    output  [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= calculate_next_state(q_reg);
    end
end

assign q = q_reg;

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;

begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] alive_neighbors;
            integer row, col;

            // Calculate the index of the current cell
            integer index = i * 16 + j;

            // Initialize the count of alive neighbors
            alive_neighbors = 3'b0;

            // Calculate the alive neighbors
            for (row = -1; row <= 1; row = row + 1) begin
                for (col = -1; col <= 1; col = col + 1) begin
                    if ((row == 0) && (col == 0)) begin
                        // Skip the current cell
                        continue;
                    end else begin
                        integer neighbor_row = (i + row + 16) % 16;
                        integer neighbor_col = (j + col + 16) % 16;
                        integer neighbor_index = neighbor_row * 16 + neighbor_col;

                        if (current_state[neighbor_index] == 1'b1) begin
                            alive_neighbors = alive_neighbors + 1'b1;
                        end
                    end
                end
            end

            // Apply the game rules
            if ((alive_neighbors == 3'b0) || (alive_neighbors == 3'b1)) begin
                next_state[index] = 1'b0;
            end else if (alive_neighbors == 3'b2) begin
                next_state[index] = current_state[index];
            end else if (alive_neighbors == 3'b3) begin
                next_state[index] = 1'b1;
            end else begin
                next_state[index] = 1'b0;
            end
        end
    end

    calculate_next_state = next_state;
end
endfunction

endmodule