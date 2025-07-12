module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Combinational logic to calculate the next state of each cell
genvar i;
generate
    for (i = 0; i < 256; i++) begin
        wire [3:0] count;
        assign count = 
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + (i % 16)]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + (i % 16)]);
        
        // Apply the game's rules to determine the next state of each cell
        assign next_grid[i] = (count == 3) ? 1'b1 : (count == 2) ? grid[i] : 1'b0;
    end
endgenerate

// Sequential block to update the grid state at each clock cycle
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
    q <= grid;
end

endmodule