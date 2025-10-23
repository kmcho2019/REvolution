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
        q_reg <= calculate_next_state(q_reg);
    end
end

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        reg [2:0] alive_neighbors;
        integer x, y;

        alive_neighbors = 0;

        for (x = -1; x <= 1; x = x + 1) begin
            for (y = -1; y <= 1; y = y + 1) begin
                if ((x!= 0) || (y!= 0)) begin
                    integer row, col;

                    row = (i + x + 16) % 16;
                    col = (j + y + 16) % 16;

                    if (current_state[row * 16 + col]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end

        if (alive_neighbors < 2 || alive_neighbors > 3) begin
            next_state[i * 16 + j] = 0;
        end else if (alive_neighbors == 3) begin
            next_state[i * 16 + j] = 1;
        end else begin
            next_state[i * 16 + j] = current_state[i * 16 + j];
        end
    end
end

calculate_next_state = next_state;

endfunction

assign q = q_reg;

endmodule