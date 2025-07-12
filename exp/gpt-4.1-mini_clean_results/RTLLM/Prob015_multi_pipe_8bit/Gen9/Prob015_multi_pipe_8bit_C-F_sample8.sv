module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // 4-bit enable shift register to track pipeline valid data through stages
    reg [3:0] mul_en_pipe;

    // Input registers: capture inputs when mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Generate partial products combinationally using conditional shifts
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1 registers: sum partial_products[0..3], partial_products[4..7]
    reg [15:0] sum_low;
    reg [15:0] sum_high;

    // Pipeline stage 2 register: final product
    reg [15:0] mul_out_reg;

    // 1) Update enable shift register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // 2) Capture inputs only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Pipeline stage 1: sum partial_products[0..3] and [4..7]
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

    // 4) Pipeline stage 2: sum of sum_low and sum_high to produce final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_low + sum_high;
        else
            mul_out_reg <= 16'b0;
    end

    // 5) Output enable: MSB of enable pipeline (indicates valid mul_out_reg)
    assign mul_en_out = mul_en_pipe[3];

    // 6) Output product only valid if mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule