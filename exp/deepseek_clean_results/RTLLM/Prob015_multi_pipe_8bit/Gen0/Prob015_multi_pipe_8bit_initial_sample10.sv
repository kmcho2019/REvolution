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
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [3:0] en_pipeline;
    
    // Partial products
    wire [7:0] pp [7:0];
    
    // Pipeline stage 1: Generate partial products
    reg [15:0] stage1 [3:0];
    
    // Pipeline stage 2: First level of addition
    reg [15:0] stage2 [1:0];
    
    // Pipeline stage 3: Final addition
    reg [15:0] mul_out_reg;
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? mul_a_reg : 8'b0;
        end
    endgenerate
    
    // Input registers and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_pipeline <= 4'b0;
        end else begin
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end
    
    // Pipeline stage 1: Organize partial products for addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1[0] <= 16'b0;
            stage1[1] <= 16'b0;
            stage1[2] <= 16'b0;
            stage1[3] <= 16'b0;
        end else if (en_pipeline[0]) begin
            stage1[0] <= {8'b0, pp[0]};
            stage1[1] <= {7'b0, pp[1], 1'b0};
            stage1[2] <= {6'b0, pp[2], 2'b0};
            stage1[3] <= {5'b0, pp[3], 3'b0};
        end
    end
    
    // Pipeline stage 2: First level of addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2[0] <= 16'b0;
            stage2[1] <= 16'b0;
        end else if (en_pipeline[1]) begin
            stage2[0] <= stage1[0] + stage1[1];
            stage2[1] <= stage1[2] + stage1[3];
        end
    end
    
    // Pipeline stage 3: Second level of addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2[0] <= 16'b0;
            stage2[1] <= 16'b0;
        end else if (en_pipeline[1]) begin
            stage2[0] <= stage1[0] + stage1[1];
            stage2[1] <= stage1[2] + stage1[3];
        end
    end
    
    // Pipeline stage 4: Final addition and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (en_pipeline[2]) begin
            mul_out_reg <= stage2[0] + stage2[1];
        end
    end
    
    // Output assignment
    assign mul_en_out = en_pipeline[3];
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule