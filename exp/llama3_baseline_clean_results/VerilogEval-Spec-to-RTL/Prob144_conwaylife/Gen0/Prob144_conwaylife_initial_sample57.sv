module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state;
reg [255:0] nextState;

integer i, j;

// Load initial state
always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        state <= nextState;
    end
end

// Calculate next state
always @(*) begin
    nextState = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] neighbors;
            // Calculate number of neighbors
            neighbors = calculateNeighbors(state, i, j);
            // Update cell state
            if (neighbors == 3'b011) begin
                // 3 neighbors: Cell becomes 1
                nextState[16*i + j] = 1'b1;
            end else if (neighbors == 3'b010) begin
                // 2 neighbors: Cell state does not change
                nextState[16*i + j] = state[16*i + j];
            end else begin
                // 0-1 or 4+ neighbors: Cell becomes 0
                nextState[16*i + j] = 1'b0;
            end
        end
    end
end

// Function to calculate number of neighbors
function reg [2:0] calculateNeighbors;
input [255:0] state;
input [3:0] i;
input [3:0] j;
reg [2:0] neighbors;

begin
    neighbors = 3'b0;
    // Check all 8 neighbors
    if (state[16*((i-1 + 16) % 16) + ((j-1 + 16) % 16)]) neighbors = neighbors + 1;
    if (state[16*((i-1 + 16) % 16) + j]) neighbors = neighbors + 1;
    if (state[16*((i-1 + 16) % 16) + ((j+1) % 16)]) neighbors = neighbors + 1;
    if (state[16*i + ((j-1 + 16) % 16)]) neighbors = neighbors + 1;
    if (state[16*i + ((j+1) % 16)]) neighbors = neighbors + 1;
    if (state[16*((i+1) % 16) + ((j-1 + 16) % 16)]) neighbors = neighbors + 1;
    if (state[16*((i+1) % 16) + j]) neighbors = neighbors + 1;
    if (state[16*((i+1) % 16) + ((j+1) % 16)]) neighbors = neighbors + 1;
    calculateNeighbors = neighbors;
end
endfunction

assign q = state;

endmodule