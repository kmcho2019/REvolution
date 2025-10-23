module Cell(
    input clk,
    input load,
    input data,
    input [7:0] neighbors,
    output reg q
);

reg next_state;

always @(posedge clk)
begin
    if (load)
    begin
        q <= data;
    end
    else
    begin
        q <= next_state;
    end
end

always @(*)
begin
    reg num_neighbors;
    num_neighbors = 0;

    for (int i = 0; i < 8; i = i + 1)
    begin
        if (neighbors[i])
        begin
            num_neighbors = num_neighbors + 1;
        end
    end

    if (num_neighbors < 2 || num_neighbors > 3)
    begin
        next_state = 0;
    end
    else if (num_neighbors == 3)
    begin
        next_state = 1;
    end
    else
    begin
        next_state = q;
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

Cell cells [15:0][15:0];

genvar i, j;

generate
    for (i = 0; i < 16; i = i + 1)
    begin
        for (j = 0; j < 16; j = j + 1)
        begin
            reg [7:0] neighbors;

            // Calculate the indices of the neighboring cells
            reg [7:0] neighbor_indices [7:0];
            neighbor_indices[0] = (i == 0? 15 : i - 1) * 16 + (j == 0? 15 : j - 1);
            neighbor_indices[1] = (i == 0? 15 : i - 1) * 16 + j;
            neighbor_indices[2] = (i == 0? 15 : i - 1) * 16 + (j == 15? 0 : j + 1);
            neighbor_indices[3] = i * 16 + (j == 0? 15 : j - 1);
            neighbor_indices[4] = i * 16 + (j == 15? 0 : j + 1);
            neighbor_indices[5] = (i == 15? 0 : i + 1) * 16 + (j == 0? 15 : j - 1);
            neighbor_indices[6] = (i == 15? 0 : i + 1) * 16 + j;
            neighbor_indices[7] = (i == 15? 0 : i + 1) * 16 + (j == 15? 0 : j + 1);

            // Assign the neighboring cells' outputs to the neighbors input
            for (int k = 0; k < 8; k = k + 1)
            begin
                assign neighbors[k] = cells[neighbor_indices[k] / 16][neighbor_indices[k] % 16].q;
            end

            // Instantiate the cell module
            Cell cell_instance (
               .clk(clk),
               .load(load),
               .data(data[i * 16 + j]),
               .neighbors(neighbors),
               .q(cells[i][j].q)
            );
        end
    end
endgenerate

// Assign the outputs of the cell modules to the q output
for (i = 0; i < 16; i = i + 1)
begin
    for (j = 0; j < 16; j = j + 1)
    begin
        assign q[i * 16 + j] = cells[i][j].q;
    end
end

endmodule