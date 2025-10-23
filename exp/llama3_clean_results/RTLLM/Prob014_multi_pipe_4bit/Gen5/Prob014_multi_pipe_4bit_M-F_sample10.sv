module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Stage 1: Initialize partial products
wire [2*size-1:0] partial_product [0:size-1];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        assign partial_product[i] = (mul_b[i]) ? (mul_a << i) : {2*size{1'b0}};
    end
endgenerate

// Stage 2: Sum partial products in pipeline stage 1
reg [2*size-1:0] sum1;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= {2*size{1'b0}};
    end else begin
        sum1 <= partial_product[0] + partial_product[1];
    end
end

// Stage 3: Sum partial products in pipeline stage 2
reg [2*size-1:0] sum2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum2 <= {2*size{1'b0}};
    end else begin
        sum2 <= sum1 + partial_product[2];
    end
end

// Stage 4: Final sum in pipeline stage 3
reg [2*size-1:0] sum3;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum3 <= {2*size{1'b0}};
    end else begin
        sum3 <= sum2 + partial_product[3];
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= sum3;
    end
end

endmodule