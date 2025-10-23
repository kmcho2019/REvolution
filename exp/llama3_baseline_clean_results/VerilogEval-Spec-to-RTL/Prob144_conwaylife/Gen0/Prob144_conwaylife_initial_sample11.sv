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

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        reg [2:0] alive_neighbors;
        alive_neighbors = count_alive_neighbors(current_state, i, j);
        if (alive_neighbors == 2'b00 || alive_neighbors == 2'b01 || alive_neighbors >= 2'b100) begin
            next_state[(i * 16) + j] = 1'b0;
        end else if (alive_neighbors == 2'b10) begin
            next_state[(i * 16) + j] = current_state[(i * 16) + j];
        end else begin
            next_state[(i * 16) + j] = 1'b1;
        end
    end
end
calculate_next_state = next_state;
endfunction

function [2:0] count_alive_neighbors;
input [255:0] current_state;
input [3:0] i, j;
reg [2:0] alive_neighbors;
integer x, y;

alive_neighbors = 0;
for (x = -1; x <= 1; x = x + 1) begin
    for (y = -1; y <= 1; y = y + 1) begin
        if (x == 0 && y == 0) begin
            continue;
        end
        if (current_state[(((i + x + 16) % 16) * 16) + ((j + y + 16) % 16)]) begin
            alive_neighbors = alive_neighbors + 1;
        end
    end
end
count_alive_neighbors = alive_neighbors;
endfunction

assign q = q_reg;

endmodule