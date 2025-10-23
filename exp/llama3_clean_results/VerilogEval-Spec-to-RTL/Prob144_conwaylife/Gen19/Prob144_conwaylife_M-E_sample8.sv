module PE(
    input [7:0] neighbors,  // neighbors' states
    input current_state,    // current state of the cell
    output reg next_state    // next state of the cell
);

always_comb begin
    reg [3:0] count;
    count = neighbors;
    if (count <= 1 || count >= 4) begin
        next_state = 1'b0;
    end else if (count == 3) begin
        next_state = 1'b1;
    end else begin
        next_state = current_state;
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Instantiate the 16x16 PE array
genvar i, j;
generate
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            wire [7:0] neighbors;
            wire current_state;
            wire next_state;

            // Calculate neighbors for the current cell
            assign neighbors[0] = grid[((i - 1 + 16) % 16) * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[1] = grid[((i - 1 + 16) % 16) * 16 + j];
            assign neighbors[2] = grid[((i - 1 + 16) % 16) * 16 + ((j + 1) % 16)];
            assign neighbors[3] = grid[i * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[4] = grid[i * 16 + ((j + 1) % 16)];
            assign neighbors[5] = grid[((i + 1) % 16) * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[6] = grid[((i + 1) % 16) * 16 + j];
            assign neighbors[7] = grid[((i + 1) % 16) * 16 + ((j + 1) % 16)];

            assign current_state = grid[i * 16 + j];

            PE u_PE(
                .neighbors(neighbors),
                .current_state(current_state),
                .next_state(next_state)
            );

            // Update grid state
            always @(posedge clk) begin
                if (load) begin
                    grid[i * 16 + j] <= data[i * 16 + j];
                end else begin
                    grid[i * 16 + j] <= next_state;
                end
            end
        end
    end
endgenerate

assign q = grid;

endmodule