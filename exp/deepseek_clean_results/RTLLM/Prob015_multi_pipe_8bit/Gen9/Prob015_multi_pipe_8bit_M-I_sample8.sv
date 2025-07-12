module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] a_reg1, b_reg1;
    reg en_reg1;
    
    reg [7:0] a_reg2, b_reg2;
    reg en_reg2;
    
    reg [15:0] result_reg;
    reg en_reg3;
    
    // Conditional partial product generation
    wire [15:0] pp0 = b_reg1[0] ? {8'b0, a_reg1} : 16'b0;
    wire [15:0] pp1 = b_reg1[1] ? {7'b0, a_reg1, 1'b0} : 16'b0;
    wire [15:0] pp2 = b_reg1[2] ? {6'b0, a_reg1, 2'b0} : 16'b0;
    wire [15:0] pp3 = b_reg1[3] ? {5'b0, a_reg1, 3'b0} : 16'b0;
    wire [15:0] pp4 = b_reg1[4] ? {4'b0, a_reg1, 4'b0} : 16'b0;
    wire [15:0] pp5 = b_reg1[5] ? {3'b0, a_reg1, 5'b0} : 16'b0;
    wire [15:0] pp6 = b_reg1[6] ? {2'b0, a_reg1, 6'b0} : 16'b0;
    wire [15:0] pp7 = b_reg1[7] ? {1'b0, a_reg1, 7'b0} : 16'b0;
    
    // Staggered addition (stage 2)
    wire [15:0] sum_low = pp0 + pp1 + pp2 + pp3;
    wire [15:0] sum_high = pp4 + pp5 + pp6 + pp7;
    
    // Clock gating control
    wire output_clk_en = en_reg3;
    wire gated_clk = clk & output_clk_en;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_reg1 <= 8'b0;
            b_reg1 <= 8'b0;
            en_reg1 <= 1'b0;
            
            a_reg2 <= 8'b0;
            b_reg2 <= 8'b0;
            en_reg2 <= 1'b0;
            
            result_reg <= 16'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            a_reg1 <= mul_a;
            b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial sums
            a_reg2 <= a_reg1;
            b_reg2 <= b_reg1;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final sum
            result_reg <= sum_low + sum_high;
            en_reg3 <= en_reg2;
        end
    end

    // Clock-gated output register
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'b0;
        end else begin
            mul_out <= result_reg;
        end
    end

    // Output enable propagation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= en_reg3;
        end
    end

endmodule