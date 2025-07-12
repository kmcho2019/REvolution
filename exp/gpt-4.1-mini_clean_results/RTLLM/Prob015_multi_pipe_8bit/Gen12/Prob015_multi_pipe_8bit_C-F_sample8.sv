module multi_pipe_8bit (
    input            clk,
    input            rst_n,
    input            mul_en_in,
    input      [7:0] mul_a,
    input      [7:0] mul_b,
    output           mul_en_out,
    output     [15:0] mul_out
);

    // Stage enable shift register (3 stages)
    reg [2:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires from multiplier bits and multiplicand
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: Pipeline registers for partial sum calculation - balanced adder tree level 1 (sum pairs)
    reg [15:0] sum_level1 [3:0];

    // Balanced adder tree level 1 combinational sums
    wire [15:0] sum0, sum1, sum2, sum3;
    assign sum0 = partial_products[0] + partial_products[1]; // sum of first pair
    assign sum1 = partial_products[2] + partial_products[3]; // sum of second pair
    assign sum2 = partial_products[4] + partial_products[5]; // sum of third pair
    assign sum3 = partial_products[6] + partial_products[7]; // sum of fourth pair

    // Stage 3: Pipeline registers for level 2 addition and output product
    reg [15:0] sum_level2; // sum of sums from level 1 pairs
    reg [15:0] mul_out_reg;

    // Enable pipeline shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // Stage 1: Input registers latch inputs on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: Register level 1 sums of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level1[0] <= 16'd0;
            sum_level1[1] <= 16'd0;
            sum_level1[2] <= 16'd0;
            sum_level1[3] <= 16'd0;
        end else begin
            sum_level1[0] <= sum0;
            sum_level1[1] <= sum1;
            sum_level1[2] <= sum2;
            sum_level1[3] <= sum3;
        end
    end

    // Stage 3: Register final product sum from sums of level 1 sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2 <= 16'd0;
            mul_out_reg <= 16'd0;
        end else begin
            // sum_level2 is sum of two pairs of sum_level1 registers
            sum_level2 <= sum_level1[0] + sum_level1[1];
            mul_out_reg <= sum_level2 + sum_level1[2] + sum_level1[3];
        end
    end

    // Output enable is the MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product gated by output enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule