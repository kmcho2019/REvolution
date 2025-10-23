module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Stage 1: Register inputs and enable
    reg             mul_en_1;
    reg     [7:0]   mul_a_reg;
    reg     [7:0]   mul_b_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_1 <= 1'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: Generate partial products and sum pairs
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin: GEN_PARTIAL_PRODUCTS
            assign pp[i] = mul_b_reg[i] ? ( {8'b0, mul_a_reg} << i ) : 16'b0;
        end
    endgenerate

    reg             mul_en_2;
    reg     [15:0]  sum_0_1;
    reg     [15:0]  sum_2_3;
    reg     [15:0]  sum_4_5;
    reg     [15:0]  sum_6_7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_2 <= 1'b0;
            sum_0_1  <= 16'b0;
            sum_2_3  <= 16'b0;
            sum_4_5  <= 16'b0;
            sum_6_7  <= 16'b0;
        end else begin
            mul_en_2 <= mul_en_1;
            if (mul_en_1) begin
                sum_0_1 <= pp[0] + pp[1];
                sum_2_3 <= pp[2] + pp[3];
                sum_4_5 <= pp[4] + pp[5];
                sum_6_7 <= pp[6] + pp[7];
            end else begin
                sum_0_1 <= 16'b0;
                sum_2_3 <= 16'b0;
                sum_4_5 <= 16'b0;
                sum_6_7 <= 16'b0;
            end
        end
    end

    // Stage 3: Sum the sums from previous stage
    reg             mul_en_3;
    reg     [15:0]  sum_01_23;
    reg     [15:0]  sum_45_67;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_3 <= 1'b0;
            sum_01_23 <= 16'b0;
            sum_45_67 <= 16'b0;
        end else begin
            mul_en_3 <= mul_en_2;
            if (mul_en_2) begin
                sum_01_23 <= sum_0_1 + sum_2_3;
                sum_45_67 <= sum_4_5 + sum_6_7;
            end else begin
                sum_01_23 <= 16'b0;
                sum_45_67 <= 16'b0;
            end
        end
    end

    // Stage 4: Final sum stage
    reg             mul_en_4;
    reg     [15:0]  mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_4 <= 1'b0;
            mul_out_reg <= 16'b0;
        end else begin
            mul_en_4 <= mul_en_3;
            if (mul_en_3) begin
                mul_out_reg <= sum_01_23 + sum_45_67;
            end else begin
                mul_out_reg <= 16'b0;
            end
        end
    end

    // Stage 5: Output register and enable delayed
    reg             mul_en_5;
    reg     [15:0]  mul_out_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_5 <= 1'b0;
            mul_out_pipe <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            mul_en_5 <= mul_en_4;
            mul_out_pipe <= mul_out_reg;
            mul_en_out <= mul_en_5;
            mul_out <= (mul_en_5) ? mul_out_pipe : 16'b0;
        end
    end

endmodule