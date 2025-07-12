module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended multiplicand
wire [7:0] ext_a = {4'b0, mul_a};

// Partial products
wire [7:0] pp [0:3];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS
        assign pp[i] = mul_b[i] ? (ext_a << i) : 8'd0;
    end
endgenerate

// Pipeline registers
reg [7:0] stage1 [0:3];
reg [7:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < size; j = j + 1) begin
            stage1[j] <= 8'd0;
        end
        sum_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // First pipeline stage: register partial products
        for (integer j = 0; j < size; j = j + 1) begin
            stage1[j] <= pp[j];
        end
        
        // Second pipeline stage: accumulate and register final sum
        sum_reg <= stage1[0] + stage1[1] + stage1[2] + stage1[3];
        mul_out <= sum_reg;
    end
end

endmodule