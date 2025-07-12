module TopModule(
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

assign q = q_reg;

function [255:0] calculate_next_state;
    input [255:0] current_state;
    reg [255:0] next_state;
    reg [2:0] alive_neighbors;

    integer i, j;

    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            alive_neighbors = 0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    alive_neighbors = alive_neighbors + get_cell_state(current_state, (i + x + 16) % 16, (j + y + 16) % 16);
                end
            end
            next_state[(i * 16) + j] = get_next_cell_state(current_state[(i * 16) + j], alive_neighbors);
        end
    end
    calculate_next_state = next_state;
endfunction

function [0:0] get_cell_state;
    input [255:0] state;
    input [3:0] row;
    input [3:0] col;
    get_cell_state = state[(row * 16) + col];
endfunction

function [0:0] get_next_cell_state;
    input [0:0] current_state;
    input [2:0] alive_neighbors;

    case (alive_neighbors)
        0, 1: get_next_cell_state = 0;
        2: get_next_cell_state = current_state;
        3: get_next_cell_state = 1;
        default: get_next_cell_state = 0;
    endcase
endfunction

endmodule