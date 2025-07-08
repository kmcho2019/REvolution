module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

// Pipeline stage 0: input registers
reg mul_en_r0;
reg [7:0] mul_a_r0;
reg [7:0] mul_b_r0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_r0 <= 1'b0;
        mul_a_r0  <= 8'd0;
        mul_b_r0  <= 8'd0;
    end else if (mul_en_in) begin
        mul_en_r0 <= 1'b1;
        mul_a_r0  <= mul_a;
        mul_b_r0  <= mul_b;
    end else begin
        mul_en_r0 <= 1'b0;
        // keep inputs or clear? Spec implies registers update only if mul_en_in active.
        // We'll keep old inputs but disable enable signal.
    end
end

// Partial product generation (stage 1)
// For each bit of mul_b_r0, generate partial product: if bit set, mul_a_r0 shifted accordingly, else zero
wire [15:0] temp [7:0];

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : partial_prod_gen
        assign temp[i] = mul_b_r0[i] ? ({8'd0, mul_a_r0} << i) : 16'd0;
    end
endgenerate

// Pipeline stage 1: sum partial products in groups for pipelined addition
// We'll add pairs of partial products stepwise in registers to pipeline
// Stage 1 registers: sum0_0 to sum0_3, each sum of two partial products

reg [15:0] sum0_0, sum0_1, sum0_2, sum0_3;
reg        mul_en_r1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_0    <= 16'd0;
        sum0_1    <= 16'd0;
        sum0_2    <= 16'd0;
        sum0_3    <= 16'd0;
        mul_en_r1 <= 1'b0;
    end else begin
        sum0_0    <= temp[0] + temp[1];
        sum0_1    <= temp[2] + temp[3];
        sum0_2    <= temp[4] + temp[5];
        sum0_3    <= temp[6] + temp[7];
        mul_en_r1 <= mul_en_r0;
    end
end

// Pipeline stage 2: add results from stage 1 pairwise
reg [15:0] sum1_0, sum1_1;
reg        mul_en_r2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_0    <= 16'd0;
        sum1_1    <= 16'd0;
        mul_en_r2 <= 1'b0;
    end else begin
        sum1_0    <= sum0_0 + sum0_1;
        sum1_1    <= sum0_2 + sum0_3;
        mul_en_r2 <= mul_en_r1;
    end
end

// Pipeline stage 3: final addition
reg [15:0] mul_out_reg;
reg        mul_en_r3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        mul_en_r3   <= 1'b0;
    end else begin
        mul_out_reg <= sum1_0 + sum1_1;
        mul_en_r3   <= mul_en_r2;
    end
end

// Output assignments
assign mul_en_out = mul_en_r3;
assign mul_out = mul_en_r3 ? mul_out_reg : 16'd0;

endmodule