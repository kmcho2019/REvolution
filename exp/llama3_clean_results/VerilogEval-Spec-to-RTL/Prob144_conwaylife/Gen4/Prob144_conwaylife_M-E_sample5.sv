module Cell(
    input clk,
    input load,
    input prev_state,
    input [8:0] neighbours,
    output reg next_state
);

always @(posedge clk) begin
    if (load) begin
        next_state <= 0; // Default to 0 when loading
    end else begin
        case (neighbours)
            0, 1: next_state <= 0;
            2: next_state <= prev_state;
            3: next_state <= 1;
            default: next_state <= 0;
        endcase
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
reg [255:0] new_grid;

// Generate 16x16 grid of cells
genvar i, j;
generate
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            // Calculate indices for neighbours, including wrap-around
            wire [8:0] neighbours;
            assign neighbours[0] = grid[(i-1+16)%16*16 + (j-1+16)%16]; // Top-left
            assign neighbours[1] = grid[(i-1+16)%16*16 + j]; // Top
            assign neighbours[2] = grid[(i-1+16)%16*16 + (j+1)%16]; // Top-right
            assign neighbours[3] = grid[i*16 + (j-1+16)%16]; // Left
            assign neighbours[4] = grid[i*16 + (j+1)%16]; // Right
            assign neighbours[5] = grid[(i+1)%16*16 + (j-1+16)%16]; // Bottom-left
            assign neighbours[6] = grid[(i+1)%16*16 + j]; // Bottom
            assign neighbours[7] = grid[(i+1)%16*16 + (j+1)%16]; // Bottom-right
            assign neighbours[8] = 0; // Reserved for future use

            // Instantiate Cell module
            Cell cell_i_j(
                .clk(clk),
                .load(load),
                .prev_state(grid[i*16 + j]),
                .neighbours(neighbours),
                .next_state(new_grid[i*16 + j])
            );
        end
    end
endgenerate

// Update grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= new_grid;
    end
    q <= grid;
end

endmodule