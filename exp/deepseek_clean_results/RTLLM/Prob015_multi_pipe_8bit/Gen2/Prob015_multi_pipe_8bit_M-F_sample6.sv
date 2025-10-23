module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Pipeline stage 2 registers
    reg [15:0] partial_sum_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] product_reg3;
    reg en_reg3;
    
    // Partial products
    wire [15:0] pp [7:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // Intermediate sum calculation
    wire [15:0] stage2_sum;
    assign stage2_sum = pp[0] + pp[1] + pp[2] + pp[3] + 
                       pp[4] + pp[5] + pp[6] + pp[7];
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            en_reg1 <= 1'b0;
            
            partial_sum_reg2 <= 16'b0;
            en_reg2 <= 1'b0;
            
            product_reg3 <= 16'b0;
            en_reg3 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product accumulation
            partial_sum_reg2 <= stage2_sum;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result registration
            product_reg3 <= partial_sum_reg2;
            en_reg3 <= en_reg2;
            
            // Output
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? product_reg3 : 16'b0;
        end
    end

endmodule