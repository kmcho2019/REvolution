module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control signals
    reg [2:0] en_pipeline;
    assign mul_en_out = en_pipeline[2];

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] carry_reg, sum_reg;
    reg [15:0] result_reg;

    // Partial product generation (optimized width)
    wire [7:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (mul_en_in & mul_b[i]) ? mul_a : 8'b0;
        end
    endgenerate

    // Stage 1: Carry-save addition (4:2 compressor)
    wire [15:0] sum01 = {8'b0, pp[0]} + {7'b0, pp[1], 1'b0};
    wire [15:0] sum23 = {6'b0, pp[2], 2'b0} + {5'b0, pp[3], 3'b0};
    wire [15:0] carry_next = (sum01 & sum23) << 1;
    wire [15:0] sum_next = sum01 ^ sum23;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            carry_reg <= 16'b0;
            sum_reg <= 16'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            carry_reg <= carry_next;
            sum_reg <= sum_next;
        end
    end

    // Stage 2: Second level addition
    wire [15:0] sum45 = {4'b0, pp[4], 4'b0} + {3'b0, pp[5], 5'b0};
    wire [15:0] sum67 = {2'b0, pp[6], 6'b0} + {1'b0, pp[7], 7'b0};
    wire [15:0] stage2_sum = sum_reg + carry_reg + sum45 + sum67;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (en_pipeline[1]) begin
            result_reg <= stage2_sum;
        end
    end

    // Enable signal pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_out = mul_en_out ? result_reg : 16'b0;

endmodule