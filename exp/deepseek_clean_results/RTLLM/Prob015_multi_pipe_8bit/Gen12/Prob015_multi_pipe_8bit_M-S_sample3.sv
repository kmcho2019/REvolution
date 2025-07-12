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
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp_reg [3:0];  // Combined partial product registers
    reg [15:0] sum_reg [1:0]; // Intermediate sum registers
    reg [2:0] en_pipeline;    // 3-stage enable pipeline

    // Partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? (a_reg << i) : 16'b0;
        end
    endgenerate

    // First stage adder tree
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];

    // Second stage adders
    wire [15:0] sum_low = pp_reg[0] + pp_reg[1];
    wire [15:0] sum_high = pp_reg[2] + pp_reg[3];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (int i = 0; i < 4; i = i + 1) pp_reg[i] <= 16'b0;
            for (int i = 0; i < 2; i = i + 1) sum_reg[i] <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Input registration and partial products
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: First level sums
            pp_reg[0] <= sum01;
            pp_reg[1] <= sum23;
            pp_reg[2] <= sum45;
            pp_reg[3] <= sum67;

            // Stage 3: Second level sums
            sum_reg[0] <= sum_low;
            sum_reg[1] <= sum_high;

            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    always @(*) begin
        mul_en_out = en_pipeline[2];
        mul_out = en_pipeline[2] ? (sum_reg[0] + sum_reg[1]) : 16'b0;
    end

endmodule