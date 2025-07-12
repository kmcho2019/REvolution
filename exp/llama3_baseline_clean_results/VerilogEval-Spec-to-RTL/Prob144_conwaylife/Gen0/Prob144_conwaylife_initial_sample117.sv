module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
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
    next_state = 0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] alive_neighbors;
            alive_neighbors = 0;
            
            // Count alive neighbors
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // Don't count the cell itself
                        continue;
                    end
                    
                    reg [7:0] row;
                    reg [7:0] col;
                    row = (i + x) % 16;
                    col = (j + y) % 16;
                    
                    if (current_state[(row * 16) + col]) begin
                        alive_neighbors <= alive_neighbors + 1;
                    end
                end
            end
            
            // Update cell state
            if ((alive_neighbors == 2) && current_state[(i * 16) + j]) begin
                // Cell stays alive
                next_state[(i * 16) + j] = 1;
            end else if ((alive_neighbors == 3)) begin
                // Cell becomes alive
                next_state[(i * 16) + j] = 1;
            end else begin
                // Cell dies
                next_state[(i * 16) + j] = 0;
            end
        end
    end
end

assign q = current_state;

endmodule