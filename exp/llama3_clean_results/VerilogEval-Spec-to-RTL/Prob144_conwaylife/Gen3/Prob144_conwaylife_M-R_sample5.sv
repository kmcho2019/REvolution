module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define a module to count alive neighbours
module count_neighbours(
    input [255:0] q,
    input [7:0] row,
    input [7:0] col,
    output reg [2:0] count
);
    always @(q or row or col) begin
        count = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    continue;
                end
                // Calculate row and column, handling wrap-around
                int new_row = (row + i + 16) % 16;
                int new_col = (col + j + 16) % 16;
                // Index into q to get the state of the neighbour
                int index = (new_row * 16) + new_col;
                if (q[index]) begin
                    count = count + 1;
                end
            end
        end
    end
endmodule

// Update q at every clock cycle
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [255:0] new_q;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                wire [2:0] neighbours;
                count_neighbours cnt_neighbours(q, i, j, neighbours);
                // Use logical operations to determine the next state
                new_q[index] <= (neighbours == 3) || (neighbours == 2 && q[index]);
            end
        end
        q <= new_q;
    end
end

endmodule