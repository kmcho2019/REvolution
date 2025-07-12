module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Stage 0 registers: capture inputs and enable
    reg         en_stage0;
    reg [7:0]   a_stage0;
    reg [7:0]   b_stage0;

    // Stage 1 registers: partial products
    reg         en_stage1;
    reg [15:0]  partial_products [7:0];

    // Stage 2 registers: partial sums (add in pairs)
    reg         en_stage2;
    reg [15:0]  sum_stage2 [3:0];

    // Stage 3 registers: final sum (add pairs from previous sum)
    reg         en_stage3;
    reg [15:0]  sum_stage3 [1:0];

    // Stage 4 register: final product output and enable
    reg         en_stage4;
    reg [15:0]  mul_out_reg;

    integer i;

    // Stage 0: Input register stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage0 <= 1'b0;
            a_stage0  <= 8'd0;
            b_stage0  <= 8'd0;
        end else begin
            en_stage0 <= mul_en_in;
            if (mul_en_in) begin
                a_stage0 <= mul_a;
                b_stage0 <= mul_b;
            end
        end
    end

    // Stage 1: Generate partial products (register outputs)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage1 <= 1'b0;
            for (i=0; i<8; i=i+1)
                partial_products[i] <= 16'd0;
        end else begin
            en_stage1 <= en_stage0;
            if (en_stage0) begin
                for (i=0; i<8; i=i+1)
                    partial_products[i] <= b_stage0[i] ? (a_stage0 << i) : 16'd0;
            end else begin
                for (i=0; i<8; i=i+1)
                    partial_products[i] <= 16'd0;
            end
        end
    end

    // Stage 2: Sum partial products in pairs (4 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage2 <= 1'b0;
            for (i=0; i<4; i=i+1)
                sum_stage2[i] <= 16'd0;
        end else begin
            en_stage2 <= en_stage1;
            if (en_stage1) begin
                sum_stage2[0] <= partial_products[0] + partial_products[1];
                sum_stage2[1] <= partial_products[2] + partial_products[3];
                sum_stage2[2] <= partial_products[4] + partial_products[5];
                sum_stage2[3] <= partial_products[6] + partial_products[7];
            end else begin
                for (i=0; i<4; i=i+1)
                    sum_stage2[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Sum the 4 partial sums in pairs (2 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage3 <= 1'b0;
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else begin
            en_stage3 <= en_stage2;
            if (en_stage2) begin
                sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
                sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
            end else begin
                sum_stage3[0] <= 16'd0;
                sum_stage3[1] <= 16'd0;
            end
        end
    end

    // Stage 4: Final sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage4 <= 1'b0;
            mul_out_reg <= 16'd0;
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            en_stage4 <= en_stage3;
            if (en_stage3) begin
                mul_out_reg <= sum_stage3[0] + sum_stage3[1];
            end else begin
                mul_out_reg <= 16'd0;
            end
            mul_en_out <= en_stage4;
            mul_out <= en_stage4 ? mul_out_reg : 16'd0;
        end
    end

endmodule