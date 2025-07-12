module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
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

wire [7:0] shifts[15:0];
integer i, j, k;
for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
        Shifter shifter(
            .input(current_state),
            .row(i),
            .col(j),
            .output(shifts[i*16 + j])
        );
    end
end

reg [255:0] accumulated_neighbors;
always @(*) begin
    accumulated_neighbors = 256'b0;
    for (i = 0; i < 256; i = i + 1) begin
        reg [7:0] neighbor_count;
        neighbor_count = 8'b0;
        for (j = 0; j < 8; j = j + 1) begin
            if (shifts[i][j]) begin
                neighbor_count = neighbor_count + 1;
            end
        end
        accumulated_neighbors[i] = neighbor_count;
    end
end

always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 256; i = i + 1) begin
        if ((accumulated_neighbors[i] == 3) || (accumulated_neighbors[i] == 2 && current_state[i])) begin
            next_state[i] = 1'b1;
        end
    end
end

assign q = current_state;

endmodule

module Shifter(
    input [255:0] input,
    input [3:0] row,
    input [3:0] col,
    output reg [7:0] output
);

reg [255:0] shifted_grid;
always @(*) begin
    shifted_grid = 256'b0;
    for (integer i = 0; i < 16; i = i + 1) begin
        for (integer j = 0; j < 16; j = j + 1) begin
            if (i == row && j == col) begin
                shifted_grid[(i*16 + j)] = input[(i*16 + j)];
            end
            if (i == row - 1 && j == col - 1) begin
                shifted_grid[(i*16 + j)] = input[((row - 1)*16 + col - 1)];
            end
            if (i == row - 1 && j == col) begin
                shifted_grid[(i*16 + j)] = input[((row - 1)*16 + col)];
            end
            if (i == row - 1 && j == col + 1) begin
                shifted_grid[(i*16 + j)] = input[((row - 1)*16 + col + 1)];
            end
            if (i == row && j == col - 1) begin
                shifted_grid[(i*16 + j)] = input[(i*16 + col - 1)];
            end
            if (i == row && j == col + 1) begin
                shifted_grid[(i*16 + j)] = input[(i*16 + col + 1)];
            end
            if (i == row + 1 && j == col - 1) begin
                shifted_grid[(i*16 + j)] = input[((row + 1)*16 + col - 1)];
            end
            if (i == row + 1 && j == col) begin
                shifted_grid[(i*16 + j)] = input[((row + 1)*16 + col)];
            end
            if (i == row + 1 && j == col + 1) begin
                shifted_grid[(i*16 + j)] = input[((row + 1)*16 + col + 1)];
            end
        end
    end
    // Apply toroidal boundary conditions
    shifted_grid[255:240] = shifted_grid[15:0];
    shifted_grid[239:224] = shifted_grid[31:16];
    shifted_grid[223:208] = shifted_grid[47:32];
    shifted_grid[207:192] = shifted_grid[63:48];
    shifted_grid[191:176] = shifted_grid[95:64];
    shifted_grid[175:160] = shifted_grid[111:96];
    shifted_grid[159:144] = shifted_grid[127:112];
    shifted_grid[143:128] = shifted_grid[143:128];
    shifted_grid[127:112] = shifted_grid[127:112];
    shifted_grid[111:96] = shifted_grid[111:96];
    shifted_grid[95:80] = shifted_grid[95:80];
    shifted_grid[79:64] = shifted_grid[79:64];
    shifted_grid[63:48] = shifted_grid[63:48];
    shifted_grid[47:32] = shifted_grid[47:32];
    shifted_grid[31:16] = shifted_grid[31:16];
    shifted_grid[15:0] = shifted_grid[15:0];
end

always @(*) begin
    output = 8'b0;
    for (integer i = 0; i < 8; i = i + 1) begin
        if (shifted_grid[(row*16 + col) + i]) begin
            output[i] = 1'b1;
        end
    end
end

endmodule