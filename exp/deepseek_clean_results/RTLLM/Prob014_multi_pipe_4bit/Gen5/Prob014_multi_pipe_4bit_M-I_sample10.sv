module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    
    // Partial products
    wire [2*size-1:0] pp [size-1:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b[i] ? (a_ext << i) : 0;
        end
    endgenerate

    // Pipeline stage 1 registers
    reg [2*size-1:0] pp_reg [size-1:0];
    
    // Pipeline stage 2 registers
    reg [2*size-1:0] sum1_reg;
    reg [2*size-1:0] sum2_reg;
    
    // Intermediate sums
    wire [2*size-1:0] sum_stage1 = pp_reg[0] + pp_reg[1];
    wire [2*size-1:0] sum_stage2 = pp_reg[2] + pp_reg[3];
    wire [2*size-1:0] final_sum = sum1_reg + sum2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= 0;
            end
            sum1_reg <= 0;
            sum2_reg <= 0;
            mul_out <= 0;
        end else begin
            // Pipeline stage 1: register partial products
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= pp[j];
            end
            
            // Pipeline stage 2: register intermediate sums
            sum1_reg <= sum_stage1;
            sum2_reg <= sum_stage2;
            
            // Final output
            mul_out <= final_sum;
        end
    end

endmodule