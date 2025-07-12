module TopModule (
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

assign q = q_reg;

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j, live_neighbors;

for (i = 0; i < 16; i++) begin
    for (j = 0; j < 16; j++) begin
        live_neighbors = 0;
        for (integer x = -1; x <= 1; x++) begin
            for (integer y = -1; y <= 1; y++) begin
                if (x == 0 && y == 0) continue;
                live_neighbors += get_cell_state(current_state, (i + x + 16) % 16, (j + y + 16) % 16);
            end
        end
        case (live_neighbors)
            0, 1: next_state[16*i + j] = 1'b0;
            2: next_state[16*i + j] = current_state[16*i + j];
            3: next_state[16*i + j] = 1'b1;
            default: next_state[16*i + j] = 1'b0;
        endcase
    end
end
calculate_next_state = next_state;
endfunction

function [0:0] get_cell_state;
input [255:0] state;
input [3:0] row;
input [3:0] col;
begin
    get_cell_state = state[16*row + col];
end
endfunction

endmodule