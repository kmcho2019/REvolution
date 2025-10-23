module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline register for input enable signal
reg [3:0] mul_en_out_reg;

// Input registers for operands
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires
wire [15:0] temp [7:0];

// Sum registers for partial sums (pipeline stages)
reg [15:0] sum0, sum1, sum2;

// Register for final product
reg [15:0] mul_out_reg;

// Input control: sample inputs and mul_en_in
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 4'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[2:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products: each temp[i] = mul_a_reg & {16{mul_b_reg[i]}} shifted left i bits
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign temp[i] = (mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stage 1: sum partial products temp[0], temp[1], temp[2]
// Using registers sum0, sum1, sum2 to accumulate the 8 partial products in 3 pipeline stages

// Stage 1: sum temp[0], temp[1], temp[2]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'd0;
    end else if (mul_en_out_reg[0]) begin
        sum0 <= temp[0] + temp[1] + temp[2];
    end else begin
        sum0 <= 16'd0;
    end
end

// Stage 2: sum temp[3], temp[4], temp[5]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 16'd0;
    end else if (mul_en_out_reg[1]) begin
        sum1 <= temp[3] + temp[4] + temp[5];
    end else begin
        sum1 <= 16'd0;
    end
end

// Stage 3: sum temp[6], temp[7]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 16'd0;
    end else if (mul_en_out_reg[2]) begin
        sum2 <= temp[6] + temp[7];
    end else begin
        sum2 <= 16'd0;
    end
end

// Final product calculation: sum sum0, sum1, sum2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_out_reg[3]) begin
        mul_out_reg <= sum0 + sum1 + sum2;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Output enable signal derived from most significant bit of mul_en_out_reg pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_out_reg[3];
    end
end

// Output assignment: output product only when enabled, else zero
always @(*) begin
    if (mul_en_out)
        mul_out = mul_out_reg;
    else
        mul_out = 16'd0;
end

endmodule