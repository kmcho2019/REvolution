module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @ (posedge clk) begin
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
reg [7:0] neighbors;

for (int i = 0; i < 16; i = i + 1) begin
    for (int j = 0; j < 16; j = j + 1) begin
        neighbors = 0;
        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    continue;
                end
                neighbors = neighbors + get_cell(current_state, (i + x + 16) % 16, (j + y + 16) % 16);
            end
        end
        next_state_reg[(i * 16) + j] = get_next_state(get_cell(current_state, i, j), neighbors);
    end
end

next_state = next_state_reg;
endfunction

function [0:0] get_cell;
input [255:0] state;
input [3:0] row;
input [3:0] col;

get_cell = state[(row * 16) + col];

endfunction

function [0:0] get_next_state;
input [0:0] current_state;
input [7:0] neighbors;

case (neighbors)
    0, 1: get_next_state = 0;
    2: get_next_state = current_state;
    3: get_next_state = 1;
    default: get_next_state = 0;
endcase

endfunction

endmodule