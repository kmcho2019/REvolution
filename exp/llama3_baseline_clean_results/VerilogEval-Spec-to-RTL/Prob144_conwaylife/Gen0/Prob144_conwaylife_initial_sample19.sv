module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;
integer alive_neighbors;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'd0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            alive_neighbors = 0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // skip self
                    end else begin
                        integer neighbor_i = (i + x + 16) % 16;
                        integer neighbor_j = (j + y + 16) % 16;
                        integer neighbor_index = neighbor_i * 16 + neighbor_j;
                        alive_neighbors = alive_neighbors + current_state[neighbor_index];
                    end
                end
            end
            integer index = i * 16 + j;
            if (alive_neighbors == 2) begin
                next_state[index] = current_state[index];
            end else if (alive_neighbors == 3) begin
                next_state[index] = 1'd1;
            end else begin
                next_state[index] = 1'd0;
            end
        end
    end
    q = current_state;
end

endmodule