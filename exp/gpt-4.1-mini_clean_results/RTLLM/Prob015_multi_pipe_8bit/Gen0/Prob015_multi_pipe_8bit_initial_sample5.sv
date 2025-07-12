module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable register (8 stages to cover pipeline delay)
    reg [7:0] mul_en_out_reg;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: for each bit of multiplier, partial product = mul_a & mul_b[i], shifted by i
    wire [15:0] temp [7:0];

    integer i;
    // Generate partial products combinationally
    generate
        genvar gi;
        for (gi = 0; gi < 8; gi = gi + 1) begin : partial_products_gen
            assign temp[gi] = mul_b_reg[gi] ? (mul_a_reg << gi) : 16'd0;
        end
    endgenerate

    // Partial sum pipeline registers (7 stages), as we need to add 8 partial products in pipeline fashion
    // We do: sum0 = temp[0] + temp[1], sum1 = sum0 + temp[2], ... sum6 = sum5 + temp[7]
    reg [15:0] sum [6:0];

    // Final product register
    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 8'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            for (i = 0; i < 7; i = i + 1)
                sum[i] <= 16'd0;
            mul_out_reg <= 16'd0;
        end else begin
            // Pipeline the enable signal
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};

            // Sample inputs when mul_en_in is high
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Pipeline the sums step by step (add partial products incrementally)

            // sum[0] = temp[0] + temp[1]
            sum[0] <= temp[0] + temp[1];
            // sum[1] = sum[0] + temp[2]
            sum[1] <= sum[0] + temp[2];
            // sum[2] = sum[1] + temp[3]
            sum[2] <= sum[1] + temp[3];
            // sum[3] = sum[2] + temp[4]
            sum[3] <= sum[2] + temp[4];
            // sum[4] = sum[3] + temp[5]
            sum[4] <= sum[3] + temp[5];
            // sum[5] = sum[4] + temp[6]
            sum[5] <= sum[4] + temp[6];
            // sum[6] = sum[5] + temp[7]
            sum[6] <= sum[5] + temp[7];

            // Final output register captures sum[6]
            mul_out_reg <= sum[6];
        end
    end

    // Output enable from the MSB of enable pipeline register (stage 7)
    assign mul_en_out = mul_en_out_reg[7];

    // Output product valid only when mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule