module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] next_q;

assign q = q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = q_reg;
    for (int i = 0; i < 256; i++) begin
        reg [2:0] neighbour_count;
        neighbour_count = 0;
        
        // Calculate the row and column of the current cell
        int row = i / 16;
        int col = i % 16;
        
        // Iterate over the 8 possible neighbour positions
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                if (x == 0 && y == 0) begin
                    // Skip the current cell
                    continue;
                end
                
                // Calculate the row and column of the neighbour
                int neighbour_row = (row + x + 16) % 16;
                int neighbour_col = (col + y + 16) % 16;
                
                // Calculate the index of the neighbour in the q register
                int neighbour_index = neighbour_row * 16 + neighbour_col;
                
                // Check if the neighbour is alive
                if (q_reg[neighbour_index] == 1) begin
                    // Increment the neighbour count
                    neighbour_count <= neighbour_count + 1;
                end
            end
        end
        
        // Apply the game rules to update the state of the current cell
        case (neighbour_count)
            0, 1: next_q[i] = 0;
            2: next_q[i] = q_reg[i];
            3: next_q[i] = 1;
            default: next_q[i] = 0;
        endcase
    end
end

endmodule