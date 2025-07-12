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
        reg [255:0] next_state;
        integer i, j;
        for (i = 0; i < 256; i++) begin
            integer alive_neighbors = 0;
            integer row = i / 16;
            integer col = i % 16;
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    integer neighbor_row = (row + x + 16) % 16;
                    integer neighbor_col = (col + y + 16) % 16;
                    integer neighbor_index = neighbor_row * 16 + neighbor_col;
                    if (state[neighbor_index]) begin
                        alive_neighbors++;
                    end
                end
            end
            if ((alive_neighbors == 0) || (alive_neighbors == 1) || (alive_neighbors >= 4)) begin
                next_state[i] <= 0;
            end else if (alive_neighbors == 3) begin
                next_state[i] <= 1;
            end else begin
                next_state[i] <= state[i];
            end
        end
        state <= next_state;
    end
end

assign q = state;

endmodule