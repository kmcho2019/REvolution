module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state, next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 0;
    for (int i = 0; i < 256; i++) begin
        int x = i % 16;
        int y = i / 16;
        int neighbors = 0;

        // Count neighbors
        for (int dx = -1; dx <= 1; dx++) begin
            for (int dy = -1; dy <= 1; dy++) begin
                if (dx == 0 && dy == 0) begin
                    continue;
                end
                int nx = (x + dx + 16) % 16;
                int ny = (y + dy + 16) % 16;
                int ni = ny * 16 + nx;
                neighbors += current_state[ni];
            end
        end

        // Update cell state
        if (current_state[i] == 1) begin
            if (neighbors < 2 || neighbors > 3) begin
                next_state[i] = 0;
            end else if (neighbors == 2 || neighbors == 3) begin
                next_state[i] = 1;
            end
        end else if (current_state[i] == 0) begin
            if (neighbors == 3) begin
                next_state[i] = 1;
            end
        end
    end
end

assign q = current_state;

endmodule