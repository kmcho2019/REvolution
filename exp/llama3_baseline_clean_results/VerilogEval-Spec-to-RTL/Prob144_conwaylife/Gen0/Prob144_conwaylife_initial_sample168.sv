module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] neighbours;
            neighbours = 0;

            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;

                    reg [4:0] idx_x, idx_y;
                    idx_x = (i + x + 16) % 16;
                    idx_y = (j + y + 16) % 16;

                    if (q[(idx_x * 16) + idx_y]) begin
                        neighbours += 1;
                    end
                end
            end

            if (neighbours <= 1 || neighbours >= 4) begin
                next_q[(i * 16) + j] = 0;
            end else if (neighbours == 2) begin
                next_q[(i * 16) + j] = q[(i * 16) + j];
            end else if (neighbours == 3) begin
                next_q[(i * 16) + j] = 1;
            end
        end
    end
end

endmodule