module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, k;

// Count neighbors for each cell
function [2:0] count_neighbors;
    input [15:0] i;
    input [15:0] j;
    reg [2:0] count;
    reg [7:0] neighbors;

    // Get the states of the eight neighboring cells
    begin
        neighbors[0] = current_state[((i+1)%16)*16 + (j+1)%16];
        neighbors[1] = current_state[((i+1)%16)*16 + j];
        neighbors[2] = current_state[((i+1)%16)*16 + (j+15)%16];
        neighbors[3] = current_state[i*16 + (j+1)%16];
        neighbors[4] = current_state[i*16 + (j+15)%16];
        neighbors[5] = current_state[((i+15)%16)*16 + (j+1)%16];
        neighbors[6] = current_state[((i+15)%16)*16 + j];
        neighbors[7] = current_state[((i+15)%16)*16 + (j+15)%16];

        // Count the number of neighbors
        count = 0;
        for (k = 0; k < 8; k = k + 1) begin
            count = count + neighbors[k];
        end
    end
    count_neighbors = count;
endfunction

// Update the state of each cell
always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            case (count_neighbors(i, j))
                0, 1: next_state[i*16 + j] = 0;
                2: next_state[i*16 + j] = current_state[i*16 + j];
                3: next_state[i*16 + j] = 1;
                default: next_state[i*16 + j] = 0;
            endcase
        end
    end
end

// Update the current state of the grid
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule