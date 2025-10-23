module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

always @(*) begin
    next_state = 0;
    for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
            int index = i * 16 + j;
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end
                    int x_index = (i + x + 16) % 16;
                    int y_index = (j + y + 16) % 16;
                    int neighbor_index = x_index * 16 + y_index;
                    if (q[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            if ((alive_neighbors == 3) || (alive_neighbors == 2 && q[index])) begin
                next_state[index] = 1;
            end else begin
                next_state[index] = 0;
            end
        end
    end
end

endmodule