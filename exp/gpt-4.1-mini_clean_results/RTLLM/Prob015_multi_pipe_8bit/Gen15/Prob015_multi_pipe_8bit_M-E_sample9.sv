module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1 registers
    reg [7:0]  mul_a_reg;
    reg [7:0]  mul_b_reg;
    reg        mul_en_s1;

    // Partial products wires (8 partial products)
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: sum partial products in pairs -> 4 sums
    reg [15:0] sum_s2 [3:0];
    reg        mul_en_s2;

    // Stage 3 registers: sum previous sums in pairs -> 2 sums
    reg [15:0] sum_s3 [1:0];
    reg        mul_en_s3;

    // Stage 4 registers: final sum
    reg [15:0] mul_out_reg;
    reg        mul_en_s4;

    integer j;

    // Stage 1: latch inputs and enable
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_s1 <= 1'b0;
        end else begin
            mul_en_s1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: sum partial products in pairs (pp0+pp1, pp2+pp3, pp4+pp5, pp6+pp7)
    always @(posedge clk) begin
        if (!rst_n) begin
            for (j=0; j<4; j=j+1) begin
                sum_s2[j] <= 16'd0;
            end
            mul_en_s2 <= 1'b0;
        end else begin
            sum_s2[0] <= pp[0] + pp[1];
            sum_s2[1] <= pp[2] + pp[3];
            sum_s2[2] <= pp[4] + pp[5];
            sum_s2[3] <= pp[6] + pp[7];
            mul_en_s2 <= mul_en_s1;
        end
    end

    // Stage 3: sum the stage 2 sums in pairs (sum_s2[0]+sum_s2[1], sum_s2[2]+sum_s2[3])
    always @(posedge clk) begin
        if (!rst_n) begin
            sum_s3[0] <= 16'd0;
            sum_s3[1] <= 16'd0;
            mul_en_s3 <= 1'b0;
        end else begin
            sum_s3[0] <= sum_s2[0] + sum_s2[1];
            sum_s3[1] <= sum_s2[2] + sum_s2[3];
            mul_en_s3 <= mul_en_s2;
        end
    end

    // Stage 4: final sum stage (sum_s3[0] + sum_s3[1])
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_s4 <= 1'b0;
        end else begin
            mul_out_reg <= sum_s3[0] + sum_s3[1];
            mul_en_s4 <= mul_en_s3;
        end
    end

    // Output enable and product assignment
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_s4;
            mul_out <= mul_en_s4 ? mul_out_reg : 16'd0;
        end
    end

endmodule