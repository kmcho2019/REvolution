module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products (8x 16-bit)
    reg [15:0] partial_products [7:0];

    // Stage 3: Intermediate sums
    reg [15:0] sum_level1 [3:0];
    reg [15:0] sum_level2 [1:0];

    // Stage 4: Final product register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Sample inputs and enable
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

    // Stage 2: Generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i +1) partial_products[i] <= 16'd0;
        end else begin
            if (mul_en_pipe[0]) begin
                for (i = 0; i < 8; i = i +1) begin
                    partial_products[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
                end
            end else begin
                for (i = 0; i < 8; i = i +1) partial_products[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Sum partial products in two levels to reduce adder depth
    // Level 1: sum pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i +1) sum_level1[i] <= 16'd0;
        end else begin
            if (mul_en_pipe[1]) begin
                for (i = 0; i < 4; i = i +1) begin
                    sum_level1[i] <= partial_products[2*i] + partial_products[2*i+1];
                end
            end else begin
                for (i = 0; i < 4; i = i +1) sum_level1[i] <= 16'd0;
            end
        end
    end

    // Level 2: sum pairs of Level 1 sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2; i = i +1) sum_level2[i] <= 16'd0;
        end else begin
            if (mul_en_pipe[2]) begin
                for (i = 0; i < 2; i = i +1) begin
                    sum_level2[i] <= sum_level1[2*i] + sum_level1[2*i+1];
                end
            end else begin
                for (i = 0; i < 2; i = i +1) sum_level2[i] <= 16'd0;
            end
        end
    end

    // Stage 4: Final product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_level2[0] + sum_level2[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable after 4 pipeline stages
    assign mul_en_out = mul_en_pipe[3];

    // Output product only when valid
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule