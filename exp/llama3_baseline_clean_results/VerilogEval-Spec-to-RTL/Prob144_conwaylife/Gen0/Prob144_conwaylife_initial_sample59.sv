module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(*) begin
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer alive_neighbors;
            alive_neighbors = 0;
            // Count alive neighbors
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue; // Skip the cell itself
                    integer neighbor_x, neighbor_y;
                    neighbor_x = (i + x + 16) % 16;
                    neighbor_y = (j + y + 16) % 16;
                    integer index;
                    index = neighbor_x * 16 + neighbor_y;
                    if (current_state[index]) alive_neighbors++;
                end
            end
            // Update cell state
            integer index;
            index = i * 16 + j;
            if (alive_neighbors == 2) begin
                next_state[index] = current_state[index];
            end else if (alive_neighbors == 3) begin
                next_state[index] = 1'b1;
            end else begin
                next_state[index] = 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule