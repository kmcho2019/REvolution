module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs
wire [7:0] a_ext = {{size{1'b0}}, mul_a};
wire [7:0] b_ext = {{size{1'b0}}, mul_b};

// Pipeline Stage 1: Partial Product Generation and Registration
reg [7:0] partial_products [0:size-1];

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_GEN
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                partial_products[i] <= 8'b0;
            end else begin
                partial_products[i] <= b_ext[i] ? (a_ext << i) : 8'b0;
            end
        end
    end
endgenerate

// Pipeline Stage 2: Adder Tree Accumulation
reg [7:0] sum_stage1 [0:1];
reg [7:0] sum_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1[0] <= 8'b0;
        sum_stage1[1] <= 8'b0;
        sum_stage2 <= 8'b0;
    end else begin
        // First level of adder tree
        sum_stage1[0] <= partial_products[0] + partial_products[1];
        sum_stage1[1] <= partial_products[2] + partial_products[3];
        
        // Second level of adder tree
        sum_stage2 <= sum_stage1[0] + sum_stage1[1];
    end
end

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_stage2;
    end
end

endmodule