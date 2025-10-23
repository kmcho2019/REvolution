module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand with proper parameterization
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Generate all possible shifted versions of multiplicand
wire [2*size-1:0] shifted_a [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : SHIFT_GEN
        assign shifted_a[i] = a_ext << i;
    end
endgenerate

// Partial products with optimized muxing
wire [2*size-1:0] partial_products [0:size-1];
generate
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign partial_products[i] = mul_b[i] ? shifted_a[i] : {2*size{1'b0}};
    end
endgenerate

// Pipeline Stage 1: First level of addition
reg [2*size-1:0] sum01_reg, sum23_reg;
wire [2*size-1:0] sum01 = partial_products[0] + partial_products[1];
wire [2*size-1:0] sum23 = partial_products[2] + partial_products[3];

// Pipeline Stage 2: Final addition
reg [2*size-1:0] final_sum_reg;
wire [2*size-1:0] final_sum = sum01_reg + sum23_reg;

// Pipeline control with optimized reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Single-cycle reset for all pipeline registers
        sum01_reg <= 0;
        sum23_reg <= 0;
        final_sum_reg <= 0;
        mul_out <= 0;
    end else begin
        // Stage 1 registers
        sum01_reg <= sum01;
        sum23_reg <= sum23;
        
        // Stage 2 register
        final_sum_reg <= final_sum;
        
        // Output register
        mul_out <= final_sum_reg;
    end
end

endmodule