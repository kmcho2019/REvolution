module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable shift register (4 stages: input + 3 pipeline stages)
    reg [3:0] mul_en_pipe;

    // Input registers: latch inputs when mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (combinational)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1: register partial products sums of halves
    reg [15:0] sum_low;  // sum of partial_products[0..3]
    reg [15:0] sum_high; // sum of partial_products[4..7]

    // Pipeline stage 2: register final product sum
    reg [15:0] mul_out_reg;

    // 1) Enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1: sum partial products in halves and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low <= 16'b0;
            sum_high <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_low <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
            sum_high <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
        end else begin
            sum_low <= 16'b0;
            sum_high <= 16'b0;
        end
    end

    // 4) Stage 2: sum halves and register final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_low + sum_high;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable is MSB of enable shift register (3 cycles latency)
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when mul_en_out asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule