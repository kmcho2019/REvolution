module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext;
assign mul_a_ext = { {size{1'b0}}, mul_a };

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (mul_b[i] == 1'b1) ? (mul_a_ext << i) : { {2*size{1'b0}} };
        
        // Add of partial products
        if (i == 0) begin
            assign stage1_reg = (rst_n == 1'b0) ? { {2*size{1'b0}} } : partial_product;
        end else begin
            wire [2*size-1:0] sum;
            assign sum = stage1_reg + partial_product;
            assign stage1_reg = (rst_n == 1'b0) ? { {2*size{1'b0}} } : sum;
        end
    end
endgenerate

// Update stage2_reg with the sum of stage1_reg
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= { {2*size{1'b0}} };
    end else begin
        stage2_reg <= stage1_reg;
    end
end

// Final product calculation
assign mul_out = (rst_n == 1'b0) ? { {2*size{1'b0}} } : stage2_reg;

endmodule