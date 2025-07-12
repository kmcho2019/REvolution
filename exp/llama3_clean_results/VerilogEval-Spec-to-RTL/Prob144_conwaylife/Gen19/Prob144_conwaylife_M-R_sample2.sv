module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Function to calculate next state of a single cell
function [0:0] calc_next_cell_state;
    input [0:0] current_state;
    input [3:0] live_neighbors;
    if (current_state == 1'b1) begin
        if (live_neighbors < 2 || live_neighbors > 3) begin
            calc_next_cell_state = 1'b0;
        end else begin
            calc_next_cell_state = 1'b1;
        end
    end else begin
        if (live_neighbors == 3) begin
            calc_next_cell_state = 1'b1;
        end else begin
            calc_next_cell_state = 1'b0;
        end
    end
endfunction

// Function to count live neighbors of a cell
function [3:0] count_live_neighbors;
    input [255:0] current_state;
    input [7:0] cell_index;
    reg [3:0] count;
    integer x, y;
    count = 0;
    for (x = -1; x <= 1; x++) begin
        for (y = -1; y <= 1; y++) begin
            if (x == 0 && y == 0) begin
                // skip current cell
            end else begin
                reg [7:0] neighbor_index;
                neighbor_index = ((cell_index / 16 + x + 16) % 16) * 16 + (cell_index % 16 + y + 16) % 16;
                count = count + current_state[neighbor_index];
            end
        end
    end
    count_live_neighbors = count;
endfunction

// Combinational logic to calculate next state
wire [255:0] next_grid;
genvar i;
generate
    for (i = 0; i < 256; i++) begin
        reg [3:0] live_neighbors;
        live_neighbors = count_live_neighbors(grid, i);
        assign next_grid[i] = calc_next_cell_state(grid[i], live_neighbors);
    end
endgenerate

// Sequential logic to update current state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
end

// Output current state
assign q = grid;

endmodule