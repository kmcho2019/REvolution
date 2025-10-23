module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define the size of the grid and the block size
localparam GRID_SIZE = 16;
localparam BLOCK_SIZE = 4;

// Define the number of blocks in each dimension
localparam NUM_BLOCKS_X = GRID_SIZE / BLOCK_SIZE;
localparam NUM_BLOCKS_Y = GRID_SIZE / BLOCK_SIZE;

// Define the total number of blocks
localparam NUM_BLOCKS = NUM_BLOCKS_X * NUM_BLOCKS_Y;

// Define the grid as a 2D array of blocks
reg [BLOCK_SIZE-1:0] grid [NUM_BLOCKS_X-1:0][NUM_BLOCKS_Y-1:0];

// Define the block-level neighbor calculation function
function [BLOCK_SIZE-1:0] calculate_neighbors;
    input [BLOCK_SIZE-1:0] block;
    input [BLOCK_SIZE-1:0] north;
    input [BLOCK_SIZE-1:0] south;
    input [BLOCK_SIZE-1:0] east;
    input [BLOCK_SIZE-1:0] west;
    reg [BLOCK_SIZE-1:0] neighbors;
    integer i, j;
    for (i = 0; i < BLOCK_SIZE; i++) begin
        for (j = 0; j < BLOCK_SIZE; j++) begin
            integer index = i * BLOCK_SIZE + j;
            reg [2:0] count = 0;
            if (i > 0) begin
                count = count + north[j];
            end
            if (i < BLOCK_SIZE - 1) begin
                count = count + south[j];
            end
            if (j > 0) begin
                count = count + east[i];
            end
            if (j < BLOCK_SIZE - 1) begin
                count = count + west[i];
            end
            if (count == 3) begin
                neighbors[index] = 1;
            end else if (count == 2 && block[index]) begin
                neighbors[index] = 1;
            end else begin
                neighbors[index] = 0;
            end
        end
    end
    calculate_neighbors = neighbors;
endfunction

// Define the hierarchical update function
function [255:0] update_grid;
    input [255:0] data;
    reg [255:0] new_grid;
    integer i, j;
    for (i = 0; i < NUM_BLOCKS_X; i++) begin
        for (j = 0; j < NUM_BLOCKS_Y; j++) begin
            integer block_index = i * NUM_BLOCKS_Y + j;
            reg [BLOCK_SIZE-1:0] block = data[block_index * BLOCK_SIZE +: BLOCK_SIZE];
            reg [BLOCK_SIZE-1:0] north, south, east, west;
            if (i > 0) begin
                north = data[(i - 1) * NUM_BLOCKS_Y * BLOCK_SIZE + j * BLOCK_SIZE +: BLOCK_SIZE];
            end else begin
                north = data[(NUM_BLOCKS_X - 1) * NUM_BLOCKS_Y * BLOCK_SIZE + j * BLOCK_SIZE +: BLOCK_SIZE];
            end
            if (i < NUM_BLOCKS_X - 1) begin
                south = data[(i + 1) * NUM_BLOCKS_Y * BLOCK_SIZE + j * BLOCK_SIZE +: BLOCK_SIZE];
            end else begin
                south = data[j * BLOCK_SIZE +: BLOCK_SIZE];
            end
            if (j > 0) begin
                east = data[i * NUM_BLOCKS_Y * BLOCK_SIZE + (j - 1) * BLOCK_SIZE +: BLOCK_SIZE];
            end else begin
                east = data[i * NUM_BLOCKS_Y * BLOCK_SIZE + (NUM_BLOCKS_Y - 1) * BLOCK_SIZE +: BLOCK_SIZE];
            end
            if (j < NUM_BLOCKS_Y - 1) begin
                west = data[i * NUM_BLOCKS_Y * BLOCK_SIZE + (j + 1) * BLOCK_SIZE +: BLOCK_SIZE];
            end else begin
                west = data[i * NUM_BLOCKS_Y * BLOCK_SIZE +: BLOCK_SIZE];
            end
            reg [BLOCK_SIZE-1:0] new_block = calculate_neighbors(block, north, south, east, west);
            new_grid[block_index * BLOCK_SIZE +: BLOCK_SIZE] = new_block;
        end
    end
    update_grid = new_grid;
endfunction

// Update the grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        q <= update_grid(q);
    end
end

endmodule