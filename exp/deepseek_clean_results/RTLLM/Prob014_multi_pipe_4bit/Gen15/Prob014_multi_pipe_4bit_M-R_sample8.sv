module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs with size zeros at MSB
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Pipeline Stage 1: Partial Product Generation
wire [2*size-1:0] partial_products [0:size-1];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_GEN
        assign partial_products[i] = mul_b[i] ? (ext_a << i) : '0;
    end
endgenerate

// Pipeline registers
reg [2*size-1:0] pp_reg [0:size-1];
reg [2*size-1:0] sum_reg;

// Pipeline Stage 1: Register partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer j = 0; j < size; j = j + 1)
            pp_reg[j] <= '0;
    end else begin
        for (integer j = 0; j < size; j = j + 1)
            pp_reg[j] <= partial_products[j];
    end
end

// Pipeline Stage 2: Accumulation
wire [2*size-1:0] next_sum;
assign next_sum = pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];

// Pipeline Stage 2: Register sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= '0;
    end else begin
        sum_reg <= next_sum;
    end
end

// Output registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= '0;
    end else begin
        mul_out <= sum_reg;
    end
end

endmodule