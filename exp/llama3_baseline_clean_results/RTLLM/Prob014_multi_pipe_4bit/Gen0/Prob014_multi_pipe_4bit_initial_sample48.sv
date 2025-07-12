module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        // Calculate partial product for each bit position
        wire [7:0] partial_product = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : 8'd0;

        // Add partial product to the intermediate sum
        if (i == 0) begin
            assign stage1_out = partial_product;
        end else begin
            reg [7:0] stage1_reg;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    stage1_reg <= 8'd0;
                end else begin
                    stage1_reg <= stage1_out + partial_product;
                end
            end
            assign stage1_out = stage1_reg;
        end
    end
endgenerate

// Second stage of the pipeline
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_out <= 8'd0;
    end else begin
        stage2_out <= stage1_out;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= stage2_out;
    end
end

endmodule