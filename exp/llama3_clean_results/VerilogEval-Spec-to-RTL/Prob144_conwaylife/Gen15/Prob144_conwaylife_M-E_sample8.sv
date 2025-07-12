module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

// Initialize next_state to zeros
initial next_state = 256'b0;

// Define the size of the sub-grid
parameter SUB_GRID_SIZE = 4;

// Define the number of sub-grids
parameter NUM_SUB_GRIDS = 16;

// Define the number of cells in the grid
parameter NUM_CELLS = 256;

// Define the number of bits required to represent the number of alive neighbors
parameter NUM_NEIGHBOR_BITS = 3;

// Function to calculate the index of a cell in the grid
function int calculate_index;
    input int row;
    input int col;
    begin
        calculate_index = (row * 16) + col;
    end
endfunction

// Function to calculate the number of alive neighbors for a cell
function int calculate_alive_neighbors;
    input int cell_index;
    begin
        int alive_neighbors = 0;
        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x!= 0 || y!= 0) begin
                    int row = (cell_index / 16) + x;
                    int col = (cell_index % 16) + y;
                    row = (row + 16) % 16;
                    col = (col + 16) % 16;
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

// Combinational logic to calculate the number of alive neighbors for each cell
always @(*) begin
    for (int i = 0; i < NUM_CELLS; i = i + 1) begin
        int alive_neighbors = calculate_alive_neighbors(i);
        if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i])) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
end

// Sequential logic to update the state of each cell and handle the pipeline architecture
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule