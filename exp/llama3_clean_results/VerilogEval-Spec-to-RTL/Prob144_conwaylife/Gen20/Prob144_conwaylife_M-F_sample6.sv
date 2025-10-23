module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'b0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int index = i * 16 + j;
            int alive_neighbors = 0;
            
            // Calculate the number of alive neighbors considering toroidal boundary conditions
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        continue; // Skip the current cell
                    end
                    
                    int neighbor_i = (i + x + 16) % 16; // Toroidal boundary condition
                    int neighbor_j = (j + y + 16) % 16; // Toroidal boundary condition
                    int neighbor_index = neighbor_i * 16 + neighbor_j;
                    
                    if (current_state[neighbor_index]) begin
                        alive_neighbors++;
                    end
                end
            end
            
            // Apply the Game of Life rules
            if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[index])) begin
                next_state[index] = 1'b1;
            end
        end
    end
end

assign q = current_state;

endmodule