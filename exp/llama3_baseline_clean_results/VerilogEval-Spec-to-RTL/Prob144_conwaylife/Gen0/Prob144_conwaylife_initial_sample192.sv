module TopModule (
    input           clk,
    input           load,
    input   [255:0] data,
    output  [255:0] q
);

reg [255:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state(current_state);
    end
end

assign q = current_state;

function [255:0] next_state;
input [255:0] state;
integer i, j;
reg [255:0] next_state;
begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            integer index = i * 16 + j;
            integer neighbors = 0;

            // count neighbors
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) continue;
                    integer nx = (i + x + 16) % 16;
                    integer ny = (j + y + 16) % 16;
                    integer neighbor_index = nx * 16 + ny;
                    if (state[neighbor_index]) neighbors = neighbors + 1;
                end
            end

            // apply game rules
            if (neighbors <= 1 || neighbors >= 4) begin
                next_state[index] = 0;
            end else if (neighbors == 2) begin
                next_state[index] = state[index];
            end else if (neighbors == 3) begin
                next_state[index] = 1;
            end
        end
    end
    next_state[255:256] = {256{1'b0}};
end
endfunction

endmodule