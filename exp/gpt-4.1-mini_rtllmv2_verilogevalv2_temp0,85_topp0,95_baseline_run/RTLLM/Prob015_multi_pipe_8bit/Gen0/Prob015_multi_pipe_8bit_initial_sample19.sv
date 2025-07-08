module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

    // Stage 0 registers: input enable and inputs
    reg         mul_en_stage0;
    reg  [7:0]  mul_a_reg;
    reg  [7:0]  mul_b_reg;

    // Partial products wires (8 partial products, each 16 bits)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PP_GEN
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for sums
    // We'll do sum in 3 stages for balanced addition:
    // Stage 1: sum pairs of partial products -> 4 sums
    reg [15:0] sum_stage1 [3:0];
    reg        en_stage1;

    // Stage 2: sum pairs of sums from stage1 -> 2 sums
    reg [15:0] sum_stage2 [1:0];
    reg        en_stage2;

    // Stage 3: sum the two sums from stage2 -> final product
    reg [15:0] mul_out_reg;
    reg        en_stage3;

    // Stage 0: capture inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage0 <= 1'b0;
            mul_a_reg     <= 8'd0;
            mul_b_reg     <= 8'd0;
        end else begin
            mul_en_stage0 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1: sum partial products in pairs, register enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1[0] <= 16'd0;
            sum_stage1[1] <= 16'd0;
            sum_stage1[2] <= 16'd0;
            sum_stage1[3] <= 16'd0;
            en_stage1     <= 1'b0;
        end else begin
            en_stage1 <= mul_en_stage0;
            if (mul_en_stage0) begin
                sum_stage1[0] <= partial_products[0] + partial_products[1];
                sum_stage1[1] <= partial_products[2] + partial_products[3];
                sum_stage1[2] <= partial_products[4] + partial_products[5];
                sum_stage1[3] <= partial_products[6] + partial_products[7];
            end
        end
    end

    // Stage 2: sum results from stage 1 in pairs, register enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            en_stage2     <= 1'b0;
        end else begin
            en_stage2 <= en_stage1;
            if (en_stage1) begin
                sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
                sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
            end
        end
    end

    // Stage 3: final sum and register output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            en_stage3   <= 1'b0;
        end else begin
            en_stage3 <= en_stage2;
            if (en_stage2) begin
                mul_out_reg <= sum_stage2[0] + sum_stage2[1];
            end
        end
    end

    // Output assignments
    assign mul_en_out = en_stage3;
    assign mul_out = en_stage3 ? mul_out_reg : 16'd0;

endmodule