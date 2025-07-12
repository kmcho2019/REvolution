module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

// Define the size of the grid
parameter GRID_SIZE = 16;

// Function to calculate the number of alive neighbors for a cell
function automatic int calculate_alive_neighbors;
    input int cell_index;
    int alive_neighbors;
    begin
        alive_neighbors = 0;
        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x != 0 || y != 0) begin
                    int row = (cell_index / 16 + x + GRID_SIZE) % GRID_SIZE;
                    int col = (cell_index % 16 + y + GRID_SIZE) % GRID_SIZE;
                    int neighbor_index = (row * 16) + col;
                    if (current_state[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
        calculate_alive_neighbors = alive_neighbors;
    end
endfunction

// Combinational logic to calculate the next state
always @(*) begin
    for (int i = 0; i < 256; i = i + 1) begin
        int alive_neighbors = calculate_alive_neighbors(i);
        if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i])) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
end

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule