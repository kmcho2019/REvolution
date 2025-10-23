module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline depth = 4 (including input registration stage)

    // Stage 1 registers
    reg             mul_en_1;
    reg     [7:0]   mul_a_reg;
    reg     [7:0]   mul_b_reg;

    // Partial products wires (each 16-bit, aligned)
    wire [15:0] temp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PARTIAL_PRODUCTS
            // If mul_b_reg[i] = 1, partial product is mul_a_reg shifted by i, else 0
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2 registers: sum of partial products in pairs
    reg [15:0] sum_0_1, sum_2_3, sum_4_5, sum_6_7;
    reg        mul_en_2;

    // Stage 3 registers: sum of pairs from previous stage
    reg [15:0] sum_01_23, sum_45_67;
    reg        mul_en_3;

    // Stage 4 registers: final sum
    reg [15:0] mul_out_reg;
    reg        mul_en_4;

    // Input stage: register inputs and enable
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

    // Stage 2: sum partial products in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1  <= 16'b0;
            sum_2_3  <= 16'b0;
            sum_4_5  <= 16'b0;
            sum_6_7  <= 16'b0;
            mul_en_2 <= 1'b0;
        end else begin
            if (mul_en_1) begin
                sum_0_1  <= temp[0] + temp[1];
                sum_2_3  <= temp[2] + temp[3];
                sum_4_5  <= temp[4] + temp[5];
                sum_6_7  <= temp[6] + temp[7];
            end else begin
                sum_0_1  <= 16'b0;
                sum_2_3  <= 16'b0;
                sum_4_5  <= 16'b0;
                sum_6_7  <= 16'b0;
            end
            mul_en_2 <= mul_en_1;
        end
    end

    // Stage 3: sum pairs from stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_23 <= 16'b0;
            sum_45_67 <= 16'b0;
            mul_en_3  <= 1'b0;
        end else begin
            if (mul_en_2) begin
                sum_01_23 <= sum_0_1 + sum_2_3;
                sum_45_67 <= sum_4_5 + sum_6_7;
            end else begin
                sum_01_23 <= 16'b0;
                sum_45_67 <= 16'b0;
            end
            mul_en_3 <= mul_en_2;
        end
    end

    // Stage 4: final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_4    <= 1'b0;
        end else begin
            if (mul_en_3) begin
                mul_out_reg <= sum_01_23 + sum_45_67;
            end else begin
                mul_out_reg <= 16'b0;
            end
            mul_en_4 <= mul_en_3;
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out     <= 16'b0;
            mul_en_out  <= 1'b0;
        end else begin
            mul_en_out <= mul_en_4;
            mul_out    <= (mul_en_4) ? mul_out_reg : 16'b0;
        end
    end

endmodule