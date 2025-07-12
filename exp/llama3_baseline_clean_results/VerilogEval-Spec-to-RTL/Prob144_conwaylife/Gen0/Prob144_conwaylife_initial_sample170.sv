module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j, neighbor_count;
reg [255:0] next_state;

always @ (posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

always @ (*) begin
    for (i = 0; i < 256; i = i + 1) begin
        next_state[i] = 1'b0; // initialize next_state
    end
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbor_count = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // do not count the cell itself as a neighbor
                    end else begin
                        // calculate the index of the neighbor
                        integer neighbor_i = (i + x + 16) % 16;
                        integer neighbor_j = (j + y + 16) % 16;
                        integer neighbor_index = (neighbor_i * 16) + neighbor_j;
                        // check if the neighbor is alive
                        if (q_reg[neighbor_index]) begin
                            neighbor_count = neighbor_count + 1;
                        end
                    end
                end
            end
            // calculate the index of the current cell
            integer current_index = (i * 16) + j;
            // update the state of the current cell based on the number of alive neighbors
            case (neighbor_count)
                2'b0, 2'b1: next_state[current_index] = 1'b0;
                2'b2: next_state[current_index] = q_reg[current_index];
                2'b3: next_state[current_index] = 1'b1;
                default: next_state[current_index] = 1'b0;
            endcase
        end
    end
end

assign q = q_reg;

endmodule