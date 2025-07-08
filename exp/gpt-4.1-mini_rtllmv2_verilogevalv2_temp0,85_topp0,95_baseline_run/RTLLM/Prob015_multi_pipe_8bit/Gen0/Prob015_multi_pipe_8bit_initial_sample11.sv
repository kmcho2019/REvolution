module multi_pipe_8bit (
    input          clk,
    input          rst_n,
    input          mul_en_in,
    input  [7:0]   mul_a,
    input  [7:0]   mul_b,
    output         mul_en_out,
    output [15:0]  mul_out
);

    // Pipeline stage 1: Input registers and enable pipeline (1-bit enable stored in MSB of 8-bit reg)
    reg [7:0] mul_en_out_reg;
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_en_out_reg <= 8'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};
            if(mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Partial product generation: 8 partial products, each 16 bits, shifted by bit index of mul_b_reg
    wire [15:0] temp [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : gen_partial_products
            assign temp[i] = mul_b_reg[i] ? ( {8'b0, mul_a_reg} << i ) : 16'b0;
        end
    endgenerate

    // Pipeline stage 2: Partial sums - sum pairs of partial products
    // sum0 = temp[0] + temp[1], sum1 = temp[2] + temp[3], sum2 = temp[4] + temp[5], sum3 = temp[6] + temp[7]
    reg [15:0] sum [3:0];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum[0] <= 16'b0;
            sum[1] <= 16'b0;
            sum[2] <= 16'b0;
            sum[3] <= 16'b0;
        end else begin
            sum[0] <= temp[0] + temp[1];
            sum[1] <= temp[2] + temp[3];
            sum[2] <= temp[4] + temp[5];
            sum[3] <= temp[6] + temp[7];
        end
    end

    // Pipeline stage 3: Sum the sums from stage 2 in pairs
    // sum_stage3_0 = sum[0] + sum[1], sum_stage3_1 = sum[2] + sum[3]
    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end else begin
            sum_stage3[0] <= sum[0] + sum[1];
            sum_stage3[1] <= sum[2] + sum[3];
        end
    end

    // Pipeline stage 4: Final sum to get the product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_out_reg <= 16'b0;
        end else begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end
    end

    // Output enable signal is the MSB bit of the mul_en_out_reg (8-bit shift register)
    assign mul_en_out = mul_en_out_reg[7];

    // Output product gated by enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule