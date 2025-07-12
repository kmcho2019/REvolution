module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend inputs to 2*size bits
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Generate all partial products
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PP_GEN
        assign pp[i] = mul_b[i] ? ext_a << i : {2*size{1'b0}};
    end
endgenerate

// Pipeline Stage 1: Sum first two partial products
reg [2*size-1:0] sum1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 0;
    end else begin
        sum1 <= pp[0] + pp[1];
    end
end

// Pipeline Stage 2: Add remaining partial products
reg [2*size-1:0] sum2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 0;
    end else begin
        sum2 <= sum1 + pp[2] + pp[3];
    end
end

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum2;
    end
end

endmodule