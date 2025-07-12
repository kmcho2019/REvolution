module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: Inputs and input enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_stage1;

    // Stage 2 registers: Partial products and enable
    reg [15:0] partial_products_reg [7:0];
    reg        mul_en_stage2;

    integer i;

    // Stage 3 registers: Final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage3;

    // Stage 1: Register inputs when enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg     <= 8'd0;
            mul_b_reg     <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: Generate and register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage2 <= 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                partial_products_reg[i] <= 16'd0;
            end
        end else begin
            mul_en_stage2 <= mul_en_stage1;
            if (mul_en_stage1) begin
                // Generate partial products based on registered inputs
                for (i = 0; i < 8; i = i + 1) begin
                    partial_products_reg[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
                end
            end else begin
                for (i = 0; i < 8; i = i + 1) begin
                    partial_products_reg[i] <= 16'd0;
                end
            end
        end
    end

    // Stage 3: Sum partial products and register final product and enable
    wire [15:0] partial_sum;
    assign partial_sum = partial_products_reg[0] + partial_products_reg[1] + partial_products_reg[2] +
                         partial_products_reg[3] + partial_products_reg[4] + partial_products_reg[5] +
                         partial_products_reg[6] + partial_products_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage3 <= 1'b0;
            mul_out_reg   <= 16'd0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;
            if (mul_en_stage2) begin
                mul_out_reg <= partial_sum;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable and product outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_stage3;
            mul_out    <= mul_en_stage3 ? mul_out_reg : 16'd0;
        end
    end

endmodule