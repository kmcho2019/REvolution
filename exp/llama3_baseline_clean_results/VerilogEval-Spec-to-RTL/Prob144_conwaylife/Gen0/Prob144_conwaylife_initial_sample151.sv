module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

// Initialize the grid with the input data
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= calculate_next_state(q_reg);
    end
end

// Combinational logic to calculate the next state
function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;

integer i, j;
reg [2:0] neighbors;

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        neighbors = 0;
        // Count the alive neighbors
        for (integer x = -1; x <= 1; x = x + 1) begin
            for (integer y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    // Do not count the cell itself
                end else begin
                    integer neighbor_x = (i + x + 16) % 16;
                    integer neighbor_y = (j + y + 16) % 16;
                    integer neighbor_index = neighbor_x * 16 + neighbor_y;
                    if (current_state[neighbor_index]) begin
                        neighbors = neighbors + 1;
                    end
                end
            end
        end
        // Calculate the next state based on the number of alive neighbors
        integer current_index = i * 16 + j;
        if (neighbors <= 1 || neighbors >= 4) begin
            next_state[current_index] = 0;
        end else if (neighbors == 2) begin
            next_state[current_index] = current_state[current_index];
        end else if (neighbors == 3) begin
            next_state[current_index] = 1;
        end
    end
end
calculate_next_state = next_state;
endfunction

assign q = q_reg;

endmodule