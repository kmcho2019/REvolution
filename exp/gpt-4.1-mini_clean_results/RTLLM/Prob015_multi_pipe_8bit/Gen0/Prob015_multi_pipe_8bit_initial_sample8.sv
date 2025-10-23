module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output            mul_en_out,
    output reg [15:0] mul_out
);

//----------------------------------------------------------------------
// Pipeline stage 1: Input registers & enable pipeline
//----------------------------------------------------------------------
// mul_en pipeline register (8-bit shift reg to hold enable along pipeline)
// Using 8 bits to cover pipeline depth, final output enable from MSB.
reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg      <= 8'b0;
        mul_b_reg      <= 8'b0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};
        // Sample inputs only when input enable asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

assign mul_en_out = mul_en_out_reg[7];

//----------------------------------------------------------------------
// Partial products generation (combinational)
// temp[i] = mul_a & {8{mul_b[i]}}, shifted i bits left
// Each partial product is 16 bits wide to hold shifted result
wire [15:0] temp [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : PARTIAL_PRODUCTS
        assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
    end
endgenerate

//----------------------------------------------------------------------
// Pipeline stages to sum partial products
// We'll add pairs of partial products in pipeline registers to balance delay

// Stage 2 sums: sum0 = temp[0] + temp[1], sum1 = temp[2] + temp[3]
//              sum2 = temp[4] + temp[5], sum3 = temp[6] + temp[7]
reg [15:0] sum_stage2 [3:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'b0;
        sum_stage2[1] <= 16'b0;
        sum_stage2[2] <= 16'b0;
        sum_stage2[3] <= 16'b0;
    end else begin
        // Update sums only if input enable pipelined bit 1 asserted
        if (mul_en_out_reg[1]) begin
            sum_stage2[0] <= temp[0] + temp[1];
            sum_stage2[1] <= temp[2] + temp[3];
            sum_stage2[2] <= temp[4] + temp[5];
            sum_stage2[3] <= temp[6] + temp[7];
        end else begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
            sum_stage2[2] <= 16'b0;
            sum_stage2[3] <= 16'b0;
        end
    end
end

// Stage 3 sums: sum4 = sum_stage2[0] + sum_stage2[1]
//              sum5 = sum_stage2[2] + sum_stage2[3]
reg [15:0] sum_stage3 [1:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'b0;
        sum_stage3[1] <= 16'b0;
    end else begin
        if (mul_en_out_reg[3]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end
    end
end

// Stage 4 sum: final_sum = sum_stage3[0] + sum_stage3[1]
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_out_reg[7]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'b0;
        end
    end
end

//----------------------------------------------------------------------
// Output assignment
//----------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
    end else begin
        if (mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'b0;
    end
end

endmodule