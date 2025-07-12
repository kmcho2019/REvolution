module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stages count: 4 stages (input reg + 3 addition stages)
    // Enable pipeline shift register, to track valid data through pipeline stages
    reg [4:0] mul_en_pipeline;

    // Input operand registers, latch inputs on enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products registers (to break combinational path)
    reg [15:0] pp_reg [7:0];

    // Partial sums pipeline registers
    reg [15:0] sum0, sum1, sum2, sum3; // Stage 1 sums
    reg [15:0] sum01, sum23;            // Stage 2 sums
    reg [15:0] mul_out_reg;             // Stage 3 final sum (product)

    integer i;

    // Enable signal pipeline for tracking valid outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipeline <= 5'b0;
        else
            mul_en_pipeline <= {mul_en_pipeline[3:0], mul_en_in};
    end

    // Input registers: latch multiplicand and multiplier only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial products generation and registering (stage 0)
    // On clock, create partial products for each bit of mul_b_reg and store in pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1) begin
                pp_reg[i] <= 16'b0;
            end
        end else if (mul_en_pipeline[0]) begin
            for (i=0; i<8; i=i+1) begin
                pp_reg[i] <= mul_b_reg[i] ? ( {8'b0, mul_a_reg} << i ) : 16'b0;
            end
        end
    end

    // Pipeline stage 1: Add partial products pairwise when data is valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'b0;
            sum1 <= 16'b0;
            sum2 <= 16'b0;
            sum3 <= 16'b0;
        end else if (mul_en_pipeline[1]) begin
            sum0 <= pp_reg[0] + pp_reg[1];
            sum1 <= pp_reg[2] + pp_reg[3];
            sum2 <= pp_reg[4] + pp_reg[5];
            sum3 <= pp_reg[6] + pp_reg[7];
        end
    end

    // Pipeline stage 2: Add sums pairwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 16'b0;
            sum23 <= 16'b0;
        end else if (mul_en_pipeline[2]) begin
            sum01 <= sum0 + sum1;
            sum23 <= sum2 + sum3;
        end
    end

    // Pipeline stage 3: Final sum (product)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipeline[3])
            mul_out_reg <= sum01 + sum23;
    end

    // Output enable is the last stage of enable pipeline
    assign mul_en_out = mul_en_pipeline[4];

    // Output product registered and gated by enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule