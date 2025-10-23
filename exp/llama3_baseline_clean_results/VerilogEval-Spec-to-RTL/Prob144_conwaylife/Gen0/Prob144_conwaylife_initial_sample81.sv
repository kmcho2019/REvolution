module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if(load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    for(int i = 0; i < 16; i = i + 1) begin
        for(int j = 0; j < 16; j = j + 1) begin
            reg [7:0] neighbors;
            reg [0:0] cell;

            cell = q[(i * 16) + j];

            neighbors = 0;

            // Count the number of alive neighbors
            for(int x = -1; x <= 1; x = x + 1) begin
                for(int y = -1; y <= 1; y = y + 1) begin
                    if(x == 0 && y == 0) begin
                        continue;
                    end

                    int row, col;
                    row = (i + x) % 16;
                    if(row < 0) row = row + 16;

                    col = (j + y) % 16;
                    if(col < 0) col = col + 16;

                    neighbors = neighbors + q[(row * 16) + col];
                end
            end

            // Apply the rules of the game
            if(neighbors <= 1) begin
                next_q[(i * 16) + j] = 0;
            end else if(neighbors == 2) begin
                next_q[(i * 16) + j] = cell;
            end else if(neighbors == 3) begin
                next_q[(i * 16) + j] = 1;
            end else begin
                next_q[(i * 16) + j] = 0;
            end
        end
    end
end

endmodule