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
    for (int i = 0; i < 256; i++) begin
        int alive_neighbours = 0;
        int x = i % 16;
        int y = i / 16;
        
        for (int dx = -1; dx <= 1; dx++) begin
            for (int dy = -1; dy <= 1; dy++) begin
                if (dx == 0 && dy == 0) begin
                    continue;
                end
                
                int nx = (x + dx + 16) % 16;
                int ny = (y + dy + 16) % 16;
                int neighbour_index = ny * 16 + nx;
                
                if (q[neighbour_index]) begin
                    alive_neighbours++;
                end
            end
        end
        
        if (alive_neighbours <= 1 || alive_neighbours >= 4) begin
            next_q[i] = 0;
        end else if (alive_neighbours == 2) begin
            next_q[i] = q[i];
        end else if (alive_neighbours == 3) begin
            next_q[i] = 1;
        end
    end
end

endmodule