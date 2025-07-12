module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;
integer alive_neighbors;

always @ (posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    next_state = 256'b0;
    for (i = 0; i < 256; i = i + 1) begin
        alive_neighbors = 0;
        x = i % 16;
        y = i / 16;
        for (j = -1; j <= 1; j = j + 1) begin
            for (integer k = -1; k <= 1; k = k + 1) begin
                if (j == 0 && k == 0) begin
                    continue;
                end
                integer neighbor_x = (x + k + 16) % 16;
                integer neighbor_y = (y + j + 16) % 16;
                integer neighbor_index = neighbor_y * 16 + neighbor_x;
                alive_neighbors = alive_neighbors + current_state[neighbor_index];
            end
        end
        if (alive_neighbors == 2) begin
            next_state[i] <= current_state[i];
        end else if (alive_neighbors == 3) begin
            next_state[i] <= 1'b1;
        end else begin
            next_state[i] <= 1'b0;
        end
    end
end

assign q = current_state;

endmodule