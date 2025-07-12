module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= calculate_next_state(q_reg);
    end
end

function [255:0] calculate_next_state;
    input [255:0] current_state;
    reg [255:0] next_state;
    reg [2:0] num_neighbors;
    integer i, j;
    begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                num_neighbors = 0;
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        integer neighbor_i = (i + x + 16) % 16;
                        integer neighbor_j = (j + y + 16) % 16;
                        integer neighbor_index = neighbor_i * 16 + neighbor_j;
                        num_neighbors = num_neighbors + current_state[neighbor_index];
                    end
                end
                integer cell_index = i * 16 + j;
                if (num_neighbors <= 1 || num_neighbors >= 4) begin
                    next_state[cell_index] = 0;
                end else if (num_neighbors == 2) begin
                    next_state[cell_index] = current_state[cell_index];
                end else if (num_neighbors == 3) begin
                    next_state[cell_index] = 1;
                end
            end
        end
        calculate_next_state = next_state;
    end
endfunction

assign q = q_reg;

endmodule