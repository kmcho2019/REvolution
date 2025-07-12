module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Zero-extended inputs
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

// Partial products
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign pp[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers
reg [2*size-1:0] stage1_sum;
reg [2*size-1:0] stage2_sum;

// Pipeline stage 1: First addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 0;
    end else begin
        stage1_sum <= pp[0] + pp[1];
    end
end

// Pipeline stage 2: Second addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 0;
    end else begin
        stage2_sum <= pp[2] + pp[3];
    end
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule