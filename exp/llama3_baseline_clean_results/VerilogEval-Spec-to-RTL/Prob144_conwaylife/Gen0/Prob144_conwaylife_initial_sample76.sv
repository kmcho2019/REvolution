module TopModule(
    input           clk,
    input           load,
    input   [255:0] data,
    output  [255:0] q
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
integer i, j;
begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            integer index = i * 16 + j;
            integer alive_neighbors = count_alive_neighbors(current_state, i, j);
            if (alive_neighbors == 2) begin
                next_state[index] = current_state[index];
            end else if (alive_neighbors == 3) begin
                next_state[index] = 1'b1;
            end else begin
                next_state[index] = 1'b0;
            end
        end
    end
    calculate_next_state = next_state;
end
endfunction

function integer count_alive_neighbors;
input [255:0] current_state;
input integer row;
input integer col;
begin
    integer count = 0;
    integer i, j;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            integer neighbor_row = (row + i + 16) % 16;
            integer neighbor_col = (col + j + 16) % 16;
            integer index = neighbor_row * 16 + neighbor_col;
            if (current_state[index] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    count_alive_neighbors = count;
end
endfunction

endmodule