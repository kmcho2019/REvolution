module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Pipeline stage 1: Load data into the first register
reg [511:0] stage1_reg;
always @(posedge clk) begin
    if (load) begin
        stage1_reg <= data;
    end else begin
        stage1_reg <= stage1_reg;
    end
end

// Pipeline stage 2: Calculate left and right neighbors for each cell
reg [511:0] stage2_reg_left, stage2_reg_right;
always @(posedge clk) begin
    for (int i = 0; i < 512; i++) begin
        // Boundary conditions
        if (i == 0) begin
            stage2_reg_left[i] <= 0;
        end else begin
            stage2_reg_left[i] <= stage1_reg[i - 1];
        end
        
        if (i == 511) begin
            stage2_reg_right[i] <= 0;
        end else begin
            stage2_reg_right[i] <= stage1_reg[i + 1];
        end
    end
end

// Pipeline stage 3: Apply Rule 90 logic
reg [511:0] stage3_reg;
always @(posedge clk) begin
    for (int i = 0; i < 512; i++) begin
        stage3_reg[i] <= stage2_reg_left[i] ^ stage2_reg_right[i];
    end
end

// Final output
assign q = stage3_reg;

endmodule