module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;
reg [2:0] num_neighbours;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 256; i = i + 1) begin
        x = i % 16;
        y = i / 16;
        num_neighbours = 3'b0;
        
        // Count neighbours
        for (j = -1; j <= 1; j = j + 1) begin
            for (int k = -1; k <= 1; k = k + 1) begin
                if ((j == 0) && (k == 0)) begin
                    // Don't count the cell itself
                end else begin
                    // Calculate the position of the neighbour, handling the toroidal edges
                    int neighbour_x = (x + k + 16) % 16;
                    int neighbour_y = (y + j + 16) % 16;
                    int neighbour_pos = neighbour_y * 16 + neighbour_x;
                    
                    // Check if the neighbour is alive
                    if (current_state[neighbour_pos]) begin
                        num_neighbours = num_neighbours + 1;
                    end
                end
            end
        end
        
        // Update the cell state based on the number of neighbours
        if (current_state[i]) begin
            // Cell is alive
            if ((num_neighbours == 2) || (num_neighbours == 3)) begin
                next_state[i] = 1'b1;
            end else begin
                next_state[i] = 1'b0;
            end
        end else begin
            // Cell is dead
            if (num_neighbours == 3) begin
                next_state[i] = 1'b1;
            end else begin
                next_state[i] = 1'b0;
            end
        end
    end
end

assign q = current_state;

endmodule