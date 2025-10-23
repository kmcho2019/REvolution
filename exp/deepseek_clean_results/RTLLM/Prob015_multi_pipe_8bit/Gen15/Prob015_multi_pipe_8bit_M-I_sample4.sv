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
    reg [15:0] pp_reg [0:3];  // Combined partial product registers
    reg [15:0] result_reg;
    reg [1:0] en_pipeline;    // Reduced to match pipeline depth

    // Gated partial product generation
    wire [15:0] pp0 = {8'b0, (b_reg[0] & en_pipeline[0]) ? a_reg : 8'b0};
    wire [15:0] pp1 = {7'b0, (b_reg[1] & en_pipeline[0]) ? a_reg : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, (b_reg[2] & en_pipeline[0]) ? a_reg : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, (b_reg[3] & en_pipeline[0]) ? a_reg : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, (b_reg[4] & en_pipeline[0]) ? a_reg : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, (b_reg[5] & en_pipeline[0]) ? a_reg : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, (b_reg[6] & en_pipeline[0]) ? a_reg : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, (b_reg[7] & en_pipeline[0]) ? a_reg : 8'b0, 7'b0};

    // Balanced pipeline additions
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    wire [15:0] final_sum = pp_reg[2] + pp_reg[3];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_reg[0] <= 16'b0;
            pp_reg[1] <= 16'b0;
            pp_reg[2] <= 16'b0;
            pp_reg[3] <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 2: Register first level sums
            pp_reg[0] <= sum01;
            pp_reg[1] <= sum23;

            // Stage 3: Register second level sums
            pp_reg[2] <= sum_low;
            pp_reg[3] <= sum_high;

            // Stage 4: Register final result
            result_reg <= final_sum;

            // Optimized enable signal pipeline
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? result_reg : 16'b0;

endmodule