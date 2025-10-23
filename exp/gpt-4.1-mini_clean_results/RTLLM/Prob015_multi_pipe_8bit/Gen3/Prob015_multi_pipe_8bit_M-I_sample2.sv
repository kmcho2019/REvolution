module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline depth: 4 stages (input reg + 3 addition stages)
    localparam PIPE_DEPTH = 4;

    // Enable pipeline shift register to track valid data through stages
    reg [PIPE_DEPTH-1:0] mul_en_pipe;

    // Input operand registers, loaded only when mul_en_in is asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: generate in a loop for clarity and synthesis efficiency
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PP_GEN
            // Left shift multiplicand by bit index if corresponding multiplier bit is set
            assign pp[i] = mul_b_reg[i] ? ( {8'b0, mul_a_reg} << i ) : 16'b0;
        end
    endgenerate

    // Pipeline registers for partial sums
    reg [15:0] sum0, sum1, sum2, sum3;
    reg [15:0] sum01, sum23;
    reg [15:0] mul_out_reg;
    reg mul_en_out_reg;

    // Input enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= {PIPE_DEPTH{1'b0}};
        else
            mul_en_pipe <= {mul_en_pipe[PIPE_DEPTH-2:0], mul_en_in};
    end

    // Input operand registers: update only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1: sum pairs of partial products
    // Use clock enable for registers to minimize toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'b0;
            sum1 <= 16'b0;
            sum2 <= 16'b0;
            sum3 <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum0 <= pp[0] + pp[1];
            sum1 <= pp[2] + pp[3];
            sum2 <= pp[4] + pp[5];
            sum3 <= pp[6] + pp[7];
        end
    end

    // Stage 2: sum results from stage 1 pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 16'b0;
            sum23 <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum01 <= sum0 + sum1;
            sum23 <= sum2 + sum3;
        end
    end

    // Stage 3: final addition to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out_reg <= 1'b0;
        end else begin
            mul_en_out_reg <= mul_en_pipe[2];
            if (mul_en_pipe[2])
                mul_out_reg <= sum01 + sum23;
        end
    end

    // Output enable is the output stage enable pipeline bit (latency = 4 cycles)
    assign mul_en_out = mul_en_out_reg;

    // Output product is valid only when mul_en_out asserted, otherwise zero
    assign mul_out = mul_en_out_reg ? mul_out_reg : 16'b0;

endmodule