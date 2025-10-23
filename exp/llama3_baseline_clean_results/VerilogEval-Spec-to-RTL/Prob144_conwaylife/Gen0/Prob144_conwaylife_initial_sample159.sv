module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg; // Register to hold the current state of the game

// Initialize the output
assign q = q_reg;

// Load the initial state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Calculate the next state of each cell
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                // Calculate the index of the current cell
                int idx = i * 16 + j;
                
                // Calculate the number of neighbors
                reg [2:0] neighbors;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue; // Skip the current cell
                        int nx = (i + x + 16) % 16;
                        int ny = (j + y + 16) % 16;
                        int nidx = nx * 16 + ny;
                        neighbors = neighbors + q_reg[nidx];
                    end
                end
                
                // Apply the game rules
                if (neighbors == 0 || neighbors == 1) begin
                    q_reg[idx] <= 0;
                end else if (neighbors == 2) begin
                    q_reg[idx] <= q_reg[idx];
                end else if (neighbors == 3) begin
                    q_reg[idx] <= 1;
                end else begin
                    q_reg[idx] <= 0;
                end
            end
        end
    end
end

endmodule