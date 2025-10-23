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
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int ni = (i + x + 16) % 16;
                    int nj = (j + y + 16) % 16;
                    if (q[ni*16 + nj]) begin
                        alive_neighbors++;
                    end
                end
            end
            if ((alive_neighbors == 0) || (alive_neighbors == 1)) begin
                next_q[i*16 + j] = 0;
            end else if (alive_neighbors == 2) begin
                next_q[i*16 + j] = q[i*16 + j];
            end else if (alive_neighbors == 3) begin
                next_q[i*16 + j] = 1;
            end else begin
                next_q[i*16 + j] = 0;
            end
        end
    end
end

endmodule