module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;
reg [255:0] stage1_out;
reg [255:0] stage2_out;
reg [255:0] stage3_out;

// Stage 1: Calculate neighbor count
always @(posedge clk) begin
    for (int i = 0; i < 256; i++) begin
        reg [3:0] count;
        count = 
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + (i % 16)]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + (i % 16)]);
        stage1_out[i] <= count;
    end
end

// Stage 2: Determine next state
always @(posedge clk) begin
    for (int i = 0; i < 256; i++) begin
        if (stage1_out[i] <= 1 || stage1_out[i] >= 4) begin
            stage2_out[i] <= 1'b0;
        end else if (stage1_out[i] == 3) begin
            stage2_out[i] <= 1'b1;
        end else begin
            stage2_out[i] <= grid[i];
        end
    end
end

// Stage 3: Load initial state
always @(posedge clk) begin
    if (load) begin
        stage3_out <= data;
    end else begin
        stage3_out <= stage2_out;
    end
end

// Stage 4: Output final state
always @(posedge clk) begin
    grid <= stage3_out;
    q <= grid;
end

endmodule