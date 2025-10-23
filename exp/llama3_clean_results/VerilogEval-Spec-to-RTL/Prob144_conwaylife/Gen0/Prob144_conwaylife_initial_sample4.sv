module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(*)
begin
    for (i = 0; i < 16; i = i + 1)
    begin
        for (j = 0; j < 16; j = j + 1)
        begin
            reg neighbors;
            reg cell_state;

            // Calculate the index of the current cell
            reg [7:0] cell_index;
            cell_index = i * 16 + j;

            // Extract the current cell's state
            cell_state = current_state[cell_index];

            // Initialize the number of neighbors
            neighbors = 0;

            // Calculate the indices of the neighboring cells
            reg [7:0] neighbor_indices [8:0];
            neighbor_indices[0] = (i == 0 ? 15 : i - 1) * 16 + (j == 0 ? 15 : j - 1);
            neighbor_indices[1] = (i == 0 ? 15 : i - 1) * 16 + j;
            neighbor_indices[2] = (i == 0 ? 15 : i - 1) * 16 + (j == 15 ? 0 : j + 1);
            neighbor_indices[3] = i * 16 + (j == 0 ? 15 : j - 1);
            neighbor_indices[4] = i * 16 + (j == 15 ? 0 : j + 1);
            neighbor_indices[5] = (i == 15 ? 0 : i + 1) * 16 + (j == 0 ? 15 : j - 1);
            neighbor_indices[6] = (i == 15 ? 0 : i + 1) * 16 + j;
            neighbor_indices[7] = (i == 15 ? 0 : i + 1) * 16 + (j == 15 ? 0 : j + 1);

            // Count the number of alive neighbors
            for (int k = 0; k < 8; k = k + 1)
            begin
                if (current_state[neighbor_indices[k]])
                begin
                    neighbors = neighbors + 1;
                end
            end

            // Update the cell's state based on the number of neighbors
            if (neighbors < 2 || neighbors > 3)
            begin
                next_state[cell_index] = 0;
            end
            else if (neighbors == 3)
            begin
                next_state[cell_index] = 1;
            end
            else
            begin
                next_state[cell_index] = cell_state;
            end
        end
    end
end

always @(posedge clk)
begin
    if (load)
    begin
        current_state <= data;
    end
    else
    begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule