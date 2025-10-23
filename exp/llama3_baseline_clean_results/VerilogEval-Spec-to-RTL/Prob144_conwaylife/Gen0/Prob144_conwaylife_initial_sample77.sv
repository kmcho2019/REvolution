module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state(q_reg);
    end
end

assign q = q_reg;

function [255:0] next_state;
input [255:0] current_state;
reg [255:0] next_state_reg;

integer i, j, k, alive_neighbors;

for (i = 0; i < 256; i = i + 1) begin
    j = i / 16; // row
    k = i % 16; // column
    alive_neighbors = 0;

    // count alive neighbors
    for (integer x = -1; x <= 1; x = x + 1) begin
        for (integer y = -1; y <= 1; y = y + 1) begin
            if (x == 0 && y == 0) begin
                continue;
            end
            integer neighbor_row = (j + x + 16) % 16;
            integer neighbor_col = (k + y + 16) % 16;
            integer neighbor_index = neighbor_row * 16 + neighbor_col;
            if (current_state[neighbor_index]) begin
                alive_neighbors = alive_neighbors + 1;
            end
        end
    end

    // apply game rules
    if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
        next_state_reg[i] = 0;
    end else if (alive_neighbors == 2) begin
        next_state_reg[i] = current_state[i];
    end else if (alive_neighbors == 3) begin
        next_state_reg[i] = 1;
    end
end

next_state = next_state_reg;

endfunction

endmodule