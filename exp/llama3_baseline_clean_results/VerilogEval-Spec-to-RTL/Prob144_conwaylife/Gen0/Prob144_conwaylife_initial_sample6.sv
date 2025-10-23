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

function [255:0] next_state;
input [255:0] current_state;
reg [255:0] next_state_reg;
integer i, j, x, y;
reg [2:0] alive_neighbours;

for (i = 0; i < 256; i = i + 1) begin
    alive_neighbours = 0;
    for (x = -1; x <= 1; x = x + 1) begin
        for (y = -1; y <= 1; y = y + 1) begin
            if ((x != 0 || y != 0) && current_state[calc_index(i, x, y)] == 1'b1) begin
                alive_neighbours = alive_neighbours + 1;
            end
        end
    end
    case (alive_neighbours)
        0, 1: next_state_reg[i] = 1'b0;
        2: next_state_reg[i] = current_state[i];
        3: next_state_reg[i] = 1'b1;
        default: next_state_reg[i] = 1'b0;
    endcase
end
next_state = next_state_reg;
endfunction

function integer calc_index;
input [7:0] i;
input [-1:1] x, y;
integer row, col, new_row, new_col;

row = i / 16;
col = i % 16;
new_row = (row + x) % 16;
new_col = (col + y) % 16;

calc_index = new_row * 16 + new_col;
endfunction

assign q = q_reg;

endmodule