module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(*) begin
    next_q = q;
    for (int x = 0; x < 16; x++) begin
        for (int y = 0; y < 16; y++) begin
            int alive_neighbors = 0;
            for (int dx = -1; dx <= 1; dx++) begin
                for (int dy = -1; dy <= 1; dy++) begin
                    if (dx == 0 && dy == 0) continue;
                    int nx = (x + dx + 16) % 16;
                    int ny = (y + dy + 16) % 16;
                    int index = nx + ny * 16;
                    if (q[index]) begin
                        alive_neighbors++;
                    end
                end
            end
            int index = x + y * 16;
            if (load) begin
                next_q[index] = data[index];
            end else begin
                if (alive_neighbors == 3 || (alive_neighbors == 2 && q[index])) begin
                    next_q[index] = 1;
                end else begin
                    next_q[index] = 0;
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule