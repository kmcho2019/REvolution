module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] stage1_reg;  // Stores pp[0] + pp[1]
reg [2*size-1:0] stage2_reg;  // Stores stage1 + pp[2]
reg [2*size-1:0] stage3_reg;  // Stores stage2 + pp[3]

// Pipeline stage 1: Compute and sum first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= {(2*size){1'b0}};
    end else begin
        stage1_reg <= (mul_b[0] ? {{(size){1'b0}}, mul_a} : 0) +
                     (mul_b[1] ? {{(size-1){1'b0}}, mul_a, 1'b0} : 0);
    end
end

// Pipeline stage 2: Add third partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= {(2*size){1'b0}};
    end else begin
        stage2_reg <= stage1_reg + 
                      (mul_b[2] ? {{(size-2){1'b0}}, mul_a, 2'b0} : 0);
    end
end

// Pipeline stage 3: Add final partial product and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_reg <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        stage3_reg <= stage2_reg + 
                     (mul_b[3] ? {{(size-3){1'b0}}, mul_a, 3'b0} : 0);
        mul_out <= stage3_reg;
    end
end

endmodule