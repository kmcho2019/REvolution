module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp_reg [3:0];  // Merged partial product registers
    reg [15:0] sum_reg;
    reg [2:0] en_pipeline;     // Simplified enable pipeline

    // Partial product generation (combinational)
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_en_in ? ({8'b0, mul_a} << i) & {16{b_reg[i]}} : 16'b0;
        end
    endgenerate

    // Stage 1: Balanced adder tree (carry-save style)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];

    // Stage 2: Intermediate sums
    wire [15:0] sum_low = pp_reg[0] + pp_reg[1];
    wire [15:0] sum_high = pp_reg[2] + pp_reg[3];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_reg[0] <= 16'b0;
            pp_reg[1] <= 16'b0;
            pp_reg[2] <= 16'b0;
            pp_reg[3] <= 16'b0;
            sum_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 0: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 1: Partial sums
            pp_reg[0] <= sum01;
            pp_reg[1] <= sum23;
            pp_reg[2] <= sum45;
            pp_reg[3] <= sum67;

            // Stage 2: Final addition
            sum_reg <= sum_low + sum_high;

            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? sum_reg : 16'b0;

endmodule