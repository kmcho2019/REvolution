module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'd0;
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            reg [2:0] neighbors;
            neighbors = count_neighbors(current_state, i, j);
            if (current_state[i*16 + j] == 1'b1) begin
                if (neighbors == 2 || neighbors == 3) begin
                    next_state[i*16 + j] = 1'b1;
                end else begin
                    next_state[i*16 + j] = 1'b0;
                end
            end else begin
                if (neighbors == 3) begin
                    next_state[i*16 + j] = 1'b1;
                end else begin
                    next_state[i*16 + j] = 1'b0;
                end
            end
        end
    end
end

function [2:0] count_neighbors;
    input [255:0] state;
    input [3:0] i;
    input [3:0] j;
    reg [2:0] neighbors;
    reg [3:0] x, y;

    neighbors = 0;
    for (x = i - 1; x <= i + 1; x++) begin
        for (y = j - 1; y <= j + 1; y++) begin
            if (x == i && y == j) begin
                // Don't count the cell itself
            end else begin
                reg [3:0] xi, yi;
                xi = (x + 16) % 16;
                yi = (y + 16) % 16;
                if (state[xi*16 + yi] == 1'b1) begin
                    neighbors = neighbors + 1;
                end
            end
        end
    end
    count_neighbors = neighbors;
endfunction

assign q = current_state;

endmodule