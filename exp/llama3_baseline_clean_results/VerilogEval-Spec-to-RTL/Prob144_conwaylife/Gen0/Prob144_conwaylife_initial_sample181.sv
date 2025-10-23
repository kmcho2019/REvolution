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
            reg [7:0] alive_neighbors;
            reg current_cell;

            // calculate the index of the current cell
            integer index = i * 16 + j;

            // get the current state of the cell
            current_cell = q[index];

            // initialize the count of alive neighbors
            alive_neighbors = 8'b0;

            // calculate the indices of the neighbors
            integer x, y;
            for (x = -1; x <= 1; x++) begin
                for (y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end

                    integer neighbor_i = (i + x + 16) % 16;
                    integer neighbor_j = (j + y + 16) % 16;
                    integer neighbor_index = neighbor_i * 16 + neighbor_j;

                    // check if the neighbor is alive
                    if (q[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1'b1;
                    end
                end
            end

            // update the next state of the cell based on the number of alive neighbors
            case (alive_neighbors)
                8'b00000001, 8'b00000000: next_q[index] = 1'b0;
                8'b00000010: next_q[index] = current_cell;
                8'b00000011: next_q[index] = 1'b1;
                default: next_q[index] = 1'b0;
            endcase
        end
    end
end

endmodule