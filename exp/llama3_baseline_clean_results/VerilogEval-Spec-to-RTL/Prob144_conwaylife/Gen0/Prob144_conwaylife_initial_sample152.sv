module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        state <= calculate_next_state(state);
    end
end

assign q = state;

function [255:0] calculate_next_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j;
reg [7:0] neighbors;

for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        neighbors = 0;
        for (integer x = -1; x <= 1; x = x + 1) begin
            for (integer y = -1; y <= 1; y = y + 1) begin
                if ((x == 0) && (y == 0)) begin
                    continue;
                end
                neighbors = neighbors + get_neighbor(current_state, i + x, j + y);
            end
        end
        next_state[(i * 16) + j] = get_next_state(current_state[(i * 16) + j], neighbors);
    end
end

calculate_next_state = next_state;
endfunction

function [2:0] get_neighbor;
input [255:0] state;
input [3:0] i;
input [3:0] j;
reg [2:0] neighbor;

if ((i < 0) || (i >= 16) || (j < 0) || (j >= 16)) begin
    neighbor = get_toroid_neighbor(state, i, j);
end else begin
    neighbor = state[(i * 16) + j];
end

get_neighbor = neighbor;
endfunction

function [2:0] get_toroid_neighbor;
input [255:0] state;
input [3:0] i;
input [3:0] j;
reg [2:0] neighbor;

if (i < 0) begin
    neighbor = state[((16 + i) * 16) + j];
end else if (i >= 16) begin
    neighbor = state[((i - 16) * 16) + j];
end else if (j < 0) begin
    neighbor = state[(i * 16) + (16 + j)];
end else if (j >= 16) begin
    neighbor = state[(i * 16) + (j - 16)];
end

get_toroid_neighbor = neighbor;
endfunction

function [0:0] get_next_state;
input [0:0] current_state;
input [2:0] neighbors;

if ((neighbors == 1'b0) || (neighbors == 1'b1)) begin
    get_next_state = 1'b0;
end else if (neighbors == 2'b10) begin
    get_next_state = current_state;
end else if (neighbors == 3'b11) begin
    get_next_state = 1'b1;
end else begin
    get_next_state = 1'b0;
end

endfunction

endmodule