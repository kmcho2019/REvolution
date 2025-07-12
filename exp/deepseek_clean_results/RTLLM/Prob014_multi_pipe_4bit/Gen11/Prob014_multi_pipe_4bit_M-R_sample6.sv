module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Input extension
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

// Pipeline stage combinational logic
wire [2*size-1:0] stage1_sum = pp[0] + pp[1];
wire [2*size-1:0] stage2_sum = pp[2] + pp[3];
wire [2*size-1:0] final_sum = stage1_sum + stage2_sum;

// Pipeline registers
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Clocked pipeline updates
always @(posedge clk) begin
    if (!rst_n) begin
        stage1_reg <= 0;
        stage2_reg <= 0;
        mul_out <= 0;
    end else begin
        stage1_reg <= stage1_sum;
        stage2_reg <= stage2_sum;
        mul_out <= final_sum;
    end
end

endmodule