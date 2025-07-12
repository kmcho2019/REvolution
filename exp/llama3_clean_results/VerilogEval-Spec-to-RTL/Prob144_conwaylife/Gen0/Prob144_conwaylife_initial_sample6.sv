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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbours;
                // calculate neighbours
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            // skip self
                            continue;
                        end
                        int idx_x = (i + x + 16) % 16;
                        int idx_y = (j + y + 16) % 16;
                        int idx = idx_x * 16 + idx_y;
                        neighbours += state[idx];
                    end
                end
                // update state
                if (neighbours <= 1) begin
                    next_state[i * 16 + j] <= 0;
                end else if (neighbours == 2) begin
                    next_state[i * 16 + j] <= state[i * 16 + j];
                end else if (neighbours == 3) begin
                    next_state[i * 16 + j] <= 1;
                end else begin
                    next_state[i * 16 + j] <= 0;
                end
            end
        end
        state <= next_state;
    end
end

assign q = state;

endmodule