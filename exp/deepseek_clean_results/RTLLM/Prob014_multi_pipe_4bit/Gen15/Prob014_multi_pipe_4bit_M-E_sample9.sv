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

// Pipeline Stage 1: Partial Product Generation and First Reduction
reg [2*size-1:0] partial_products [0:size-1];
reg [2*size-1:0] sum_stage1, carry_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < size; i = i + 1)
            partial_products[i] <= '0;
        sum_stage1 <= '0;
        carry_stage1 <= '0;
    end else begin
        // Generate partial products (masked by mul_b bits)
        for (integer i = 0; i < size; i = i + 1)
            partial_products[i] <= mul_b[i] ? (ext_a << i) : '0;

        // First stage Wallace tree compression (3:2)
        {carry_stage1, sum_stage1} = 
            partial_products[0] + partial_products[1] + partial_products[2];
    end
end

// Pipeline Stage 2: Final Addition and Output
reg [2*size-1:0] sum_stage2, carry_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= '0;
        carry_stage2 <= '0;
        mul_out <= '0;
    end else begin
        // Second stage compression (include remaining partial product)
        {carry_stage2, sum_stage2} = 
            sum_stage1 + carry_stage1 + partial_products[3];

        // Final addition and output
        mul_out <= sum_stage2 + carry_stage2;
    end
end

endmodule