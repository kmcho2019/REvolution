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
    reg [15:0] pp_low_reg, pp_high_reg;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Partial products with enable gating
    wire [15:0] pp0 = mul_en_in ? {8'b0, b_reg[0] ? a_reg : 8'b0} : 16'b0;
    wire [15:0] pp1 = mul_en_in ? {7'b0, (b_reg[1] ? a_reg : 8'b0), 1'b0} : 16'b0;
    wire [15:0] pp2 = mul_en_in ? {6'b0, (b_reg[2] ? a_reg : 8'b0), 2'b0} : 16'b0;
    wire [15:0] pp3 = mul_en_in ? {5'b0, (b_reg[3] ? a_reg : 8'b0), 3'b0} : 16'b0;
    wire [15:0] pp4 = mul_en_in ? {4'b0, (b_reg[4] ? a_reg : 8'b0), 4'b0} : 16'b0;
    wire [15:0] pp5 = mul_en_in ? {3'b0, (b_reg[5] ? a_reg : 8'b0), 5'b0} : 16'b0;
    wire [15:0] pp6 = mul_en_in ? {2'b0, (b_reg[6] ? a_reg : 8'b0), 6'b0} : 16'b0;
    wire [15:0] pp7 = mul_en_in ? {1'b0, (b_reg[7] ? a_reg : 8'b0), 7'b0} : 16'b0;

    // Balanced adder tree (2 levels)
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    
    // Intermediate sums
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;

    // Final sum
    wire [15:0] final_sum = pp_low_reg + pp_high_reg;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_low_reg <= 16'b0;
            pp_high_reg <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: Register partial sums
            pp_low_reg <= sum_low;
            pp_high_reg <= sum_high;
            
            // Stage 3: Register final result
            result_reg <= final_sum;
            
            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule