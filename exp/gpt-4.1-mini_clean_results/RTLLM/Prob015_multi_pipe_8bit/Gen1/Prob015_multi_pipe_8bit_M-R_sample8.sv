module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline depth = 4

    // Enable shift register pipeline for enable signal tracking
    reg [3:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: register inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg   <= 8'b0;
            mul_b_reg   <= 8'b0;
        end else begin
            mul_en_pipe[0] <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            // Shift enable signals through pipeline
            mul_en_pipe[3:1] <= mul_en_pipe[2:0];
        end
    end

    // Partial products: combinational generation based on registered inputs
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PARTIAL_PRODUCTS_GEN
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: sum partial products in pairs - registered
    reg [15:0] sum_stage2 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
            sum_stage2[2] <= 16'b0;
            sum_stage2[3] <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
            sum_stage2[2] <= 16'b0;
            sum_stage2[3] <= 16'b0;
        end
    end

    // Stage 3: sum pairs from stage 2 - combinational then registered
    wire [15:0] sum_stage3_w0 = sum_stage2[0] + sum_stage2[1];
    wire [15:0] sum_stage3_w1 = sum_stage2[2] + sum_stage2[3];

    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3[0] <= sum_stage3_w0;
            sum_stage3[1] <= sum_stage3_w1;
        end else begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end
    end

    // Stage 4: final sum - combinational then registered
    wire [15:0] final_sum_w = sum_stage3[0] + sum_stage3[1];
    reg  [15:0] final_product_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_product_reg <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            final_product_reg <= final_sum_w;
        end else begin
            final_product_reg <= 16'b0;
        end
    end

    // Output enable signal registered at stage 3 output stage (pipeline stage 4)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'b0;
        end else begin
            mul_en_out <= mul_en_pipe[3];
            mul_out    <= mul_en_pipe[3] ? final_product_reg : 16'b0;
        end
    end

endmodule