module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_out;
reg [2*size-1:0] stage2_out;
wire [2*size-1:0] partial_products [0:size-1];

// Generate partial products for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i]? (mul_a << i) : {2*size{1'b0}});
    end
endgenerate

// Stage 1: Accumulate partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_out <= {2*size{1'b0}};
    end else begin
        stage1_out <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            stage1_out <= stage1_out + partial_products[i];
        end
    end
end

// Stage 2: Store the result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_out <= {2*size{1'b0}};
    end else begin
        stage2_out <= stage1_out;
    end
end

// Final stage: Output the result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= stage2_out;
    end
end

endmodule