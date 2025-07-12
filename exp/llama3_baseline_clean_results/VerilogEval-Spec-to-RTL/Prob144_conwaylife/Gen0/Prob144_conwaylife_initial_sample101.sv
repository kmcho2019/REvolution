module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        reg [255:0] next_state;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int idx = i * 16 + j;
                int alive_neighbors = 0;

                // Count neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int ni = (i + x + 16) % 16;
                        int nj = (j + y + 16) % 16;
                        int nidx = ni * 16 + nj;
                        if (current_state[nidx]) alive_neighbors++;
                    end
                end

                // Apply game rules
                if (current_state[idx]) begin
                    if (alive_neighbors < 2 || alive_neighbors > 3) begin
                        next_state[idx] = 0;
                    end else begin
                        next_state[idx] = current_state[idx];
                    end
                end else begin
                    if (alive_neighbors == 3) begin
                        next_state[idx] = 1;
                    end else begin
                        next_state[idx] = 0;
                    end
                end
            end
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule