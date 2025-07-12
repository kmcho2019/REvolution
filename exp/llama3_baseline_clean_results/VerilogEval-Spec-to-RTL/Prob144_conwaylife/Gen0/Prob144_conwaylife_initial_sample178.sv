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
    for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end
                    int idx = ((i + x + 16) % 16) * 16 + ((j + y + 16) % 16);
                    if (q[idx]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            int idx = i * 16 + j;
            if (alive_neighbors == 3 || (alive_neighbors == 2 && q[idx])) begin
                next_q[idx] = 1'b1;
            end else begin
                next_q[idx] = 1'b0;
            end
        end
    end
end

endmodule