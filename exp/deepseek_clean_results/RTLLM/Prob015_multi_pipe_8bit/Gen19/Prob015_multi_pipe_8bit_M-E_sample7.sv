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
    reg [15:0] pp [7:0];      // Partial products
    reg [15:0] sum_reg, carry_reg; // Carry-save registers
    reg [2:0] en_pipeline;     // 3-stage enable pipeline

    // Generate all partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (int i=0; i<8; i=i+1) pp[i] <= 16'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            for (int i=0; i<8; i=i+1)
                pp[i] <= (mul_a << i) & {16{mul_b[i]}};
        end
    end

    // Stage 1: First level of 3:2 compressors
    wire [15:0] sum1 [2:0], carry1 [2:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {sum1[0], carry1[0]} <= {16'b0, 16'b0};
            {sum1[1], carry1[1]} <= {16'b0, 16'b0};
            {sum1[2], carry1[2]} <= {16'b0, 16'b0};
        end else if (en_pipeline[0]) begin
            // Compress 8 products to 6 (3 groups)
            {sum1[0], carry1[0]} <= pp[0] + pp[1] + pp[2];
            {sum1[1], carry1[1]} <= pp[3] + pp[4] + pp[5];
            {sum1[2], carry1[2]} <= pp[6] + pp[7] + 16'b0;
        end
    end

    // Stage 2: Second level compression
    reg [15:0] sum2, carry2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum2 <= 16'b0;
            carry2 <= 16'b0;
        end else if (en_pipeline[1]) begin
            // Compress 6 to 4 (sum1 + carry1)
            {sum2, carry2} <= sum1[0] + carry1[0] + sum1[1];
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 16'b0;
            carry_reg <= 16'b0;
        end else if (en_pipeline[2]) begin
            // Final carry-propagate addition
            sum_reg <= sum2 + carry2 + sum1[2] + carry1[1] + carry1[2];
        end
    end

    // Enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipeline <= 3'b0;
        else
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? sum_reg : 16'b0;

endmodule