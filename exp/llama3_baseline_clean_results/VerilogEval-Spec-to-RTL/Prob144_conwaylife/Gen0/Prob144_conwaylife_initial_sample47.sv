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
    next_q = q;
    for (int i = 0; i < 256; i++) begin
        reg [2:0] alive_neighbours;
        alive_neighbours = 0;
        
        // Calculate row and column
        reg [3:0] row, col;
        row = i / 16;
        col = i % 16;
        
        // Check all eight possible neighbour positions
        for (int dr = -1; dr <= 1; dr++) begin
            for (int dc = -1; dc <= 1; dc++) begin
                if (dr == 0 && dc == 0) continue;  // Skip the cell itself
                
                reg [3:0] nr, nc;
                nr = (row + dr) % 16;
                if (nr < 0) nr += 16;
                nc = (col + dc) % 16;
                if (nc < 0) nc += 16;
                
                reg [7:0] n_idx;
                n_idx = nr * 16 + nc;
                
                if (q[n_idx]) begin
                    alive_neighbours <= alive_neighbours + 1;
                end
            end
        end
        
        // Apply the rules of the game
        if (alive_neighbours < 2 || alive_neighbours > 3) begin
            next_q[i] <= 0;
        end else if (alive_neighbours == 3) begin
            next_q[i] <= 1;
        end
    end
end

endmodule