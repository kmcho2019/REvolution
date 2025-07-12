module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & (mul_en_in | (|en_pipeline));

    // Pipeline control registers
    reg [3:0] en_pipeline;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) en_pipeline <= 4'b0;
        else en_pipeline <= {en_pipeline[2:0], mul_en_in};
    end

    // Stage 1: Input splitting and registration
    reg [7:0] a_reg, b_reg;
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: Parallel 4-bit multiplications
    wire [7:0] a_low = a_reg[3:0];
    wire [7:0] a_high = a_reg[7:4];
    wire [7:0] b_low = b_reg[3:0];
    wire [7:0] b_high = b_reg[7:4];

    // Low 4x4 multiplier (Wallace tree)
    wire [7:0] pp0_low = {4'b0, a_low & {4{b_low[0]}}};
    wire [7:0] pp1_low = {3'b0, a_low & {4{b_low[1]}}, 1'b0};
    wire [7:0] pp2_low = {2'b0, a_low & {4{b_low[2]}}, 2'b0};
    wire [7:0] pp3_low = {1'b0, a_low & {4{b_low[3]}}, 3'b0};

    // High 4x4 multiplier (Wallace tree)
    wire [7:0] pp0_high = {4'b0, a_high & {4{b_high[0]}}};
    wire [7:0] pp1_high = {3'b0, a_high & {4{b_high[1]}}, 1'b0};
    wire [7:0] pp2_high = {2'b0, a_high & {4{b_high[2]}}, 2'b0};
    wire [7:0] pp3_high = {1'b0, a_high & {4{b_high[3]}}, 3'b0};

    // Carry-save addition stage
    reg [7:0] sum_low, carry_low;
    reg [7:0] sum_high, carry_high;
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            {sum_low, carry_low} <= 16'b0;
            {sum_high, carry_high} <= 16'b0;
        end else if (en_pipeline[0]) begin
            // Wallace tree reduction for low bits
            {carry_low[6:0], sum_low} = pp0_low + pp1_low;
            {carry_low[7], sum_low} = sum_low + pp2_low + {carry_low[6:0], 1'b0};
            carry_low = carry_low | ({7'b0, sum_low[7]} + pp3_low[7]);
            sum_low = sum_low + pp3_low + {carry_low[6:0], 1'b0};

            // Wallace tree reduction for high bits
            {carry_high[6:0], sum_high} = pp0_high + pp1_high;
            {carry_high[7], sum_high} = sum_high + pp2_high + {carry_high[6:0], 1'b0};
            carry_high = carry_high | ({7'b0, sum_high[7]} + pp3_high[7]);
            sum_high = sum_high + pp3_high + {carry_high[6:0], 1'b0};
        end
    end

    // Stage 3: Final accumulation
    reg [15:0] partial_result;
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) partial_result <= 16'b0;
        else if (en_pipeline[1]) begin
            partial_result <= ({sum_high, 8'b0} + {4'b0, sum_low, 4'b0}) + 
                            ({carry_high, 8'b0} + {4'b0, carry_low, 4'b0});
        end
    end

    // Stage 4: Output registration
    reg [15:0] result_reg;
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) result_reg <= 16'b0;
        else if (en_pipeline[2]) result_reg <= partial_result;
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg : 16'b0;

endmodule