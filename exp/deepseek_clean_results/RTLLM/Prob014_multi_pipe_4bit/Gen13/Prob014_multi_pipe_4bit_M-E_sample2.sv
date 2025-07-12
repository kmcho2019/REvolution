module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Partial product generation
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PP_GEN
        assign pp[i] = mul_b[i] ? {{(size){1'b0}}, mul_a} << i : {2*size{1'b0}};
    end
endgenerate

// Stage 1: First level compression using Wallace tree
wire [2*size-1:0] sum1, carry1;
reg [2*size-1:0] sum1_reg, carry1_reg;

// 3:2 compressor for pp[0], pp[1], pp[2]
assign sum1[2*size-1:0] = pp[0] ^ pp[1] ^ pp[2];
assign carry1[2*size-1:1] = (pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2]);
assign carry1[0] = 1'b0;

// Pipeline register for stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_reg <= 0;
        carry1_reg <= 0;
    end else begin
        sum1_reg <= sum1 + pp[3];  // Add remaining partial product
        carry1_reg <= carry1 << 1; // Align carry bits
    end
end

// Stage 2: Final addition
reg [2*size-1:0] final_sum;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= 0;
    end else begin
        final_sum <= sum1_reg + carry1_reg;
    end
end

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= final_sum;
    end
end

endmodule