module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] partial_products [0:7];
    reg [15:0] sum_stage1, carry_stage1;
    reg [15:0] sum_stage2, carry_stage2;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Generate all partial products
    always @(*) begin
        if (en_pipeline[0]) begin
            for (integer i = 0; i < 8; i = i + 1) begin
                partial_products[i] = b_reg[i] ? {8'b0, a_reg} << i : 16'b0;
            end
        end else begin
            for (integer i = 0; i < 8; i = i + 1) begin
                partial_products[i] = 16'b0;
            end
        end
    end

    // Wallace Tree Stage 1: First level of 3:2 compressors
    always @(*) begin
        if (en_pipeline[1]) begin
            // Compress first 4 partial products
            {carry_stage1, sum_stage1} = 
                partial_products[0] + partial_products[1] + partial_products[2];
            
            // Compress next 4 partial products
            {carry_stage2, sum_stage2} = 
                partial_products[3] + partial_products[4] + partial_products[5];
        end else begin
            carry_stage1 = 16'b0;
            sum_stage1 = 16'b0;
            carry_stage2 = 16'b0;
            sum_stage2 = 16'b0;
        end
    end

    // Pipeline control and final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            result_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Register inputs and generate partial products
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            
            // Stage 2: Register first level compression results
            sum_stage1 <= sum_stage1;
            carry_stage1 <= carry_stage1;
            sum_stage2 <= sum_stage2;
            carry_stage2 <= carry_stage2;
            
            // Stage 3: Final addition (carry propagate)
            result_reg <= sum_stage1 + carry_stage1 + sum_stage2 + carry_stage2 + 
                          partial_products[6] + partial_products[7];
            
            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule