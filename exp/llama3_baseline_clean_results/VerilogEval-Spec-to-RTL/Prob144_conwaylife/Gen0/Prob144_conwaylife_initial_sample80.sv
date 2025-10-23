module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

// Initialize the current state
initial begin
    current_state = 256'd0;
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state(current_state);
    end
end

// Combinational logic to calculate the next state
function [255:0] next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;

begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            // Calculate the indices of the neighboring cells
            integer x, y, alive_neighbors;
            alive_neighbors = 0;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    integer neighbor_i, neighbor_j;
                    neighbor_i = (i + x + 16) % 16;
                    neighbor_j = (j + y + 16) % 16;
                    if (current_state[neighbor_i * 16 + neighbor_j]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end

            // Update the cell's state based on the number of alive neighbors
            if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                next_state[i * 16 + j] = 1'b0;
            end else if (alive_neighbors == 2) begin
                next_state[i * 16 + j] = current_state[i * 16 + j];
            end else if (alive_neighbors == 3) begin
                next_state[i * 16 + j] = 1'b1;
            end
        end
    end
    return next_state;
end
endfunction

// Assign the current state to the output
assign q = current_state;

endmodule