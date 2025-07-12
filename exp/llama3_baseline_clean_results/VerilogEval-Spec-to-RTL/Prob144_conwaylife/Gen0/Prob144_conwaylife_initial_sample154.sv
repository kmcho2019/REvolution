module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to count the number of neighbors for a cell
    function integer count_neighbors;
        input [255:0] state;
        input [7:0] row;
        input [7:0] col;
        reg [3:0] neighbors;

        neighbors = 0;

        // Check all 8 neighboring cells
        for (integer i = -1; i <= 1; i++) begin
            for (integer j = -1; j <= 1; j++) begin
                if ((i != 0 || j != 0) && state[((row + i + 16) % 16) * 16 + (col + j + 16) % 16]) begin
                    neighbors = neighbors + 1;
                end
            end
        end

        return neighbors;
    endfunction

    // Combinational logic to calculate the next state
    always @(*) begin
        reg [255:0] next_state;

        // If load is high, load the new data
        if (load) begin
            next_state = data;
        end else begin
            // Iterate over each cell in the grid
            for (integer i = 0; i < 16; i++) begin
                for (integer j = 0; j < 16; j++) begin
                    // Count the number of neighbors for the current cell
                    reg [3:0] neighbors;
                    neighbors = count_neighbors(q, i, j);

                    // Update the state of the cell based on the number of neighbors
                    case (neighbors)
                        0, 1: next_state[i * 16 + j] = 0;
                        2: next_state[i * 16 + j] = q[i * 16 + j];
                        3: next_state[i * 16 + j] = 1;
                        default: next_state[i * 16 + j] = 0;
                    endcase
                end
            end
        end

        // Assign the next state to the output
        q <= next_state;
    end

endmodule