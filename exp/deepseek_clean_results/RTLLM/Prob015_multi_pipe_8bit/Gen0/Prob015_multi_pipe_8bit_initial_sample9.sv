module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers for control signals
    reg [2:0] enable_pipe;

    // Input registers
    reg [7:0] a_reg, b_reg;

    // Partial product generation wires
    wire [7:0] pp [7:0];

    // Pipeline stage 1 registers (partial products)
    reg [15:0] stage1_pp [7:0];

    // Pipeline stage 2 registers (reduced sums)
    reg [15:0] sum1, sum2, sum3, sum4;

    // Pipeline stage 3 registers (final product)
    reg [15:0] product_reg;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b[i] ? mul_a : 8'b0;
        end
    endgenerate

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 3'b0;
        end else begin
            enable_pipe <= {enable_pipe[1:0], mul_en_in};
        end
    end

    // Stage 1: Input sampling and partial product generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (integer j = 0; j < 8; j = j + 1) begin
                stage1_pp[j] <= 16'b0;
            end
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            for (integer j = 0; j < 8; j = j + 1) begin
                stage1_pp[j] <= {8'b0, pp[j]};
            end
        end
    end

    // Stage 2: First level of partial sum reduction
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 16'b0;
            sum2 <= 16'b0;
            sum3 <= 16'b0;
            sum4 <= 16'b0;
        end else if (enable_pipe[0]) begin
            // Shift partial products according to their weight
            sum1 <= (stage1_pp[0]) + (stage1_pp[1] << 1);
            sum2 <= (stage1_pp[2] << 2) + (stage1_pp[3] << 3);
            sum3 <= (stage1_pp[4] << 4) + (stage1_pp[5] << 5);
            sum4 <= (stage1_pp[6] << 6) + (stage1_pp[7] << 7);
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'b0;
        end else if (enable_pipe[1]) begin
            product_reg <= sum1 + sum2 + sum3 + sum4;
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[2];
    assign mul_out = mul_en_out ? product_reg : 16'b0;

endmodule