module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_sum;
reg [2*size-1:0] stage2_sum;

// Generate partial products
wire [2*size-1:0] partial_products [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i] == 1'b1)? ({size{1'b0}} << i | mul_a) : {2*size{1'b0}};
    end
endgenerate

// Sum partial products
assign stage1_sum = {2*size{1'b0}};
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= {2*size{1'b0}};
    end else begin
        stage1_sum <= {2*size{1'b0}};
        for (int j = 0; j < size; j++) begin
            stage1_sum = stage1_sum + partial_products[j];
        end
    end
end

// Update registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage2_sum <= stage1_sum;
        mul_out <= stage2_sum;
    end
end

endmodule