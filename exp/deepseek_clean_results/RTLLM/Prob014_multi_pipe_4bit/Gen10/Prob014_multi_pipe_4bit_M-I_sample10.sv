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

// Partial products generation
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign pp[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers
reg [2*size-1:0] sum_01;  // Stores pp0 + pp1
reg [2*size-1:0] sum_23;  // Stores pp2 + pp3

// Pipeline Stage 1: First two partial products
always @(posedge clk) begin
    if (!rst_n) begin
        sum_01 <= 0;
    end else begin
        sum_01 <= pp[0] + pp[1];
    end
end

// Pipeline Stage 2: Last two partial products and final sum
always @(posedge clk) begin
    if (!rst_n) begin
        sum_23 <= 0;
        mul_out <= 0;
    end else begin
        sum_23 <= pp[2] + pp[3];
        mul_out <= sum_01 + sum_23;  // Final addition
    end
end

endmodule