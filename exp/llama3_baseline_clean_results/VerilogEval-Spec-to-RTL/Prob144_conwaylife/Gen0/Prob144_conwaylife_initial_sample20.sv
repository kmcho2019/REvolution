module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

// Load data into q_reg when load is high
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Calculate the next state of the game
        q_reg <= calculate_next_state(q_reg);
    end
end

// Output the current state of the game
assign q = q_reg;

// Function to calculate the next state of the game
function [255:0] calculate_next_state;
    input [255:0] current_state;
    reg [255:0] next_state;
    reg [2:0] neighbours;

    for (int i = 0; i < 256; i = i + 1) begin
        // Calculate the row and column of the current cell
        int row = i / 16;
        int col = i % 16;

        // Initialize the number of neighbours
        neighbours = 0;

        // Count the number of neighbours
        for (int r = -1; r <= 1; r = r + 1) begin
            for (int c = -1; c <= 1; c = c + 1) begin
                if ((r == 0) && (c == 0)) begin
                    // Skip the current cell
                    continue;
                end

                int n_row = (row + r + 16) % 16;
                int n_col = (col + c + 16) % 16;
                int n_index = n_row * 16 + n_col;

                if (current_state[n_index]) begin
                    neighbours = neighbours + 1;
                end
            end
        end

        // Update the state of the current cell
        if ((neighbours == 2) && current_state[i]) begin
            // Cell state does not change
            next_state[i] = 1;
        end else if ((neighbours == 3) || ((neighbours == 2) && !current_state[i])) begin
            // Cell becomes 1
            next_state[i] = 1;
        end else begin
            // Cell becomes 0
            next_state[i] = 0;
        end
    end

    calculate_next_state = next_state;
endfunction

endmodule