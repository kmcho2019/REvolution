module TopModule(
    input clk,
    input load,
    input logic [255:0] data,
    output logic [255:0] q
);

logic [255:0] current_state;

// Function to calculate the number of alive neighbors for a cell
function logic [2:0] count_neighbors(logic [255:0] state, int cell_index);
    logic [2:0] neighbors;
    for (int x = -1; x <= 1; x++) begin
        for (int y = -1; y <= 1; y++) begin
            if (x != 0 || y != 0) begin
                int row = (cell_index / 16) + x;
                int col = (cell_index % 16) + y;
                row = (row + 16) % 16;
                col = (col + 16) % 16;
                int neighbor_index = (row * 16) + col;
                neighbors += state[neighbor_index];
            end
        end
    end
    return neighbors;
endfunction

// Sequential logic to update the state of each cell
always_ff @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        logic [255:0] next_state;
        for (int i = 0; i < 256; i++) begin
            logic [2:0] alive_neighbors = count_neighbors(current_state, i);
            next_state[i] = (alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i]);
        end
        current_state <= next_state;
    end
end

// Output logic
assign q = current_state;

endmodule