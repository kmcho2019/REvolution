module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Enable pipeline (4 stages)
    reg [3:0] mul_en_pipe;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1 registers: partial products (registered to break combinational path)
    reg [15:0] pp_reg [7:0];

    // Stage 2 registers: sum partial products in two groups (0..3 and 4..7)
    reg [15:0] sum_lower_reg;
    reg [15:0] sum_upper_reg;

    // Stage 3 register: final product sum
    reg [15:0] mul_out_reg;

    integer i;

    // Sample inputs and input enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    wire [15:0] partial_products [7:0];
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Register partial products at stage 1 (to reduce combinational delay)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= partial_products[i];
        end else begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end
    end

    // Stage 2: sum partial products in two groups and register
    wire [15:0] sum_lower = pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
    wire [15:0] sum_upper = pp_reg[4] + pp_reg[5] + pp_reg[6] + pp_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lower_reg <= 16'd0;
            sum_upper_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_lower_reg <= sum_lower;
            sum_upper_reg <= sum_upper;
        end else begin
            sum_lower_reg <= 16'd0;
            sum_upper_reg <= 16'd0;
        end
    end

    // Stage 3: final sum of the two partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_lower_reg + sum_upper_reg;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Stage 4: register output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // Output mux: valid output product or zero
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule