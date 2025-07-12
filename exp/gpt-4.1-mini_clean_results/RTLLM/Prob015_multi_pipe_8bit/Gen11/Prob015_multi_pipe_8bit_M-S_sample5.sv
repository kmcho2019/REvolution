module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (3 stages)
    reg [2:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products registers
    reg [15:0] partial_products_reg [7:0];

    integer i;

    // Stage 3: Sum register and output
    reg [15:0] mul_out_reg;

    // Pipeline enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // Stage 1: Register inputs when mul_en_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: Generate and register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                partial_products_reg[i] <= 16'b0;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                // Each partial product is either (mul_a_reg << i) or zero
                partial_products_reg[i] <= mul_b_reg[i] ? ({{8{1'b0}}, mul_a_reg} << i) : 16'b0;
            end
        end
    end

    // Stage 3: Sum partial products and register output
    wire [15:0] partial_sum;
    assign partial_sum = partial_products_reg[0] + partial_products_reg[1] + partial_products_reg[2] +
                         partial_products_reg[3] + partial_products_reg[4] + partial_products_reg[5] +
                         partial_products_reg[6] + partial_products_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= partial_sum;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable derived from the last pipeline stage
    assign mul_en_out = mul_en_pipe[2];

    // Output product valid only when mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule