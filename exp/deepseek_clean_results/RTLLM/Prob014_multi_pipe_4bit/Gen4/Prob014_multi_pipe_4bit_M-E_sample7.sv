module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs
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
    reg [2*size-1:0] sum_reg;
    reg [2*size-1:0] carry_reg;
    
    // Intermediate sums
    wire [2*size-1:0] stage1_sum;
    wire [2*size-1:0] stage1_carry;
    
    // First reduction (3:2 compressor)
    assign stage1_sum = pp_reg[0] ^ pp_reg[1] ^ pp_reg[2];
    assign stage1_carry = ((pp_reg[0] & pp_reg[1]) | 
                         ((pp_reg[0] & pp_reg[2]) | 
                         ((pp_reg[1] & pp_reg[2])) << 1;
    
    // Second reduction (3:2 compressor)
    wire [2*size-1:0] stage2_sum = stage1_sum ^ stage1_carry ^ pp_reg[3];
    wire [2*size-1:0] stage2_carry = ((stage1_sum & stage1_carry) | 
                                     (stage1_sum & pp_reg[3]) | 
                                     (stage1_carry & pp_reg[3])) << 1;
    
    // Final addition
    wire [2*size-1:0] final_sum = stage2_sum + stage2_carry;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= 0;
            end
            sum_reg <= 0;
            carry_reg <= 0;
            mul_out <= 0;
        end else begin
            // Pipeline stage 1: register partial products
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= pp[j];
            end
            
            // Pipeline stage 2: register intermediate sums
            sum_reg <= stage2_sum;
            carry_reg <= stage2_carry;
            
            // Final output
            mul_out <= final_sum;
        end
    end

endmodule