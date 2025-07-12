module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state_reg;
reg [255:0] next_state_reg;

always @(posedge clk) begin
    if (load) begin
        state_reg <= data;
    end else begin
        state_reg <= next_state_reg;
    end
end

wire [7:0] neighbors [15:0][15:0];

reg [255:0] next_state;

always @(posedge clk) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            wire [7:0] neighbor_count;
            neighbor_count = 8'd0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        // skip self
                        continue;
                    end
                    int idx_x = (i + x + 16) % 16;
                    int idx_y = (j + y + 16) % 16;
                    int idx = idx_x * 16 + idx_y;
                    neighbor_count += state_reg[idx];
                end
            end
            next_state[i * 16 + j] <= (neighbor_count <= 1'd1)? 1'd0 :
                                        (neighbor_count == 2'd2)? state_reg[i * 16 + j] :
                                        (neighbor_count == 3'd3)? 1'd1 : 1'd0;
        end
    end
    next_state_reg <= next_state;
end

assign q = state_reg;

endmodule