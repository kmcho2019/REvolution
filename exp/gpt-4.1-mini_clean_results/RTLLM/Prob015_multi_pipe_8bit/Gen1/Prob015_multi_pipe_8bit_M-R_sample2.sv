module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

//---------------------------------------------------------------------
// Stage 0: Input registers and enable pipeline
//---------------------------------------------------------------------

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [2:0] en_pipe; // 3-stage pipeline of enable signals

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        en_pipe   <= 3'd0;
    end else begin
        // Always latch inputs every cycle (no gating on mul_en_in)
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;

        // Shift enable pipeline and insert current mul_en_in LSB
        en_pipe <= {en_pipe[1:0], mul_en_in};
    end
end

assign mul_en_out = en_pipe[2];

//---------------------------------------------------------------------
// Stage 1: Partial products generation (combinational)
//---------------------------------------------------------------------

wire [15:0] partial_products [7:0];

genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
    end
endgenerate

//---------------------------------------------------------------------
// Stage 2: Partial sum registers (sum pairs of partial products)
//---------------------------------------------------------------------

reg [15:0] sum0_reg, sum1_reg, sum2_reg, sum3_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_reg <= 16'd0;
        sum1_reg <= 16'd0;
        sum2_reg <= 16'd0;
        sum3_reg <= 16'd0;
    end else if (en_pipe[1]) begin
        sum0_reg <= partial_products[0] + partial_products[1];
        sum1_reg <= partial_products[2] + partial_products[3];
        sum2_reg <= partial_products[4] + partial_products[5];
        sum3_reg <= partial_products[6] + partial_products[7];
    end else begin
        sum0_reg <= 16'd0;
        sum1_reg <= 16'd0;
        sum2_reg <= 16'd0;
        sum3_reg <= 16'd0;
    end
end

//---------------------------------------------------------------------
// Stage 3: Final product register (sum all partial sums)
//---------------------------------------------------------------------

reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (en_pipe[2]) begin
        mul_out_reg <= sum0_reg + sum1_reg + sum2_reg + sum3_reg;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

//---------------------------------------------------------------------
// Output assignment
//---------------------------------------------------------------------

assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule