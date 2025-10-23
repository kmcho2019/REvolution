module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline register for enable signal: 4 stages for pipelining control
reg [3:0] mul_en_out_reg;

// Input operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products: 8 partial products, each 16-bit shifted version of mul_a_reg masked by mul_b_reg bit
wire [15:0] temp [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stage 1 registers: sum groups of partial products
// sum0: temp[0] + temp[1] + temp[2]
// sum1: temp[3] + temp[4] + temp[5]
// sum2: temp[6] + temp[7]
reg [15:0] sum0, sum1, sum2;

// Pipeline stage 2 registers:
// sum01: sum0 + sum1
// sum2  : carry forwarded from stage 1 (sum2)
reg [15:0] sum01;
reg [15:0] sum2_reg;

// Pipeline stage 3 register: final sum of sum01 and sum2_reg
reg [15:0] mul_out_reg;

// Input control and mul_en pipeline shift register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 4'd0;
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[2:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: sum partial products groups, enabled by mul_en_out_reg[0]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
    end else if (mul_en_out_reg[0]) begin
        sum0 <= temp[0] + temp[1] + temp[2];
        sum1 <= temp[3] + temp[4] + temp[5];
        sum2 <= temp[6] + temp[7];
    end else begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
    end
end

// Stage 2: sum sum0 + sum1; register sum2 from previous stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum01    <= 16'd0;
        sum2_reg <= 16'd0;
    end else if (mul_en_out_reg[1]) begin
        sum01    <= sum0 + sum1;
        sum2_reg <= sum2;
    end else begin
        sum01    <= 16'd0;
        sum2_reg <= 16'd0;
    end
end

// Stage 3: final sum of sum01 and sum2_reg to get product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_out_reg[2]) begin
        mul_out_reg <= sum01 + sum2_reg;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Output enable and final output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= mul_en_out_reg[3];
        mul_out    <= mul_en_out_reg[3] ? mul_out_reg : 16'd0;
    end
end

endmodule