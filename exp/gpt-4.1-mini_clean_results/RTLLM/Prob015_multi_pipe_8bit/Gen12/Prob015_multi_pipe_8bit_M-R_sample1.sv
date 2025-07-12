module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline registers for input enable and output enable signals
reg [3:0] mul_en_pipe;

// Input operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires (generated combinationally)
wire [15:0] pp [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : pp_gen
        assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 1 pipeline registers: pairwise sums of partial products
reg [15:0] sum_stage1_0, sum_stage1_1, sum_stage1_2, sum_stage1_3;
// sum_stage1_0 = pp[0] + pp[1]
// sum_stage1_1 = pp[2] + pp[3]
// sum_stage1_2 = pp[4] + pp[5]
// sum_stage1_3 = pp[6] + pp[7]

// Stage 2 pipeline registers: sums of stage 1 results
reg [15:0] sum_stage2_0, sum_stage2_1;
// sum_stage2_0 = sum_stage1_0 + sum_stage1_1
// sum_stage2_1 = sum_stage1_2 + sum_stage1_3

// Stage 3 pipeline register: final sum
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers and operands
        mul_en_pipe <= 4'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
        sum_stage1_3 <= 16'd0;
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
        mul_out_reg <= 16'd0;
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        // Pipeline input enable signals
        mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

        // Sample inputs when input enable asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 1: sum pairwise partial products when valid
        if (mul_en_pipe[0]) begin
            sum_stage1_0 <= pp[0] + pp[1];
            sum_stage1_1 <= pp[2] + pp[3];
            sum_stage1_2 <= pp[4] + pp[5];
            sum_stage1_3 <= pp[6] + pp[7];
        end else begin
            sum_stage1_0 <= 16'd0;
            sum_stage1_1 <= 16'd0;
            sum_stage1_2 <= 16'd0;
            sum_stage1_3 <= 16'd0;
        end

        // Stage 2: sum results of stage 1 pairs when valid
        if (mul_en_pipe[1]) begin
            sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
            sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
        end else begin
            sum_stage2_0 <= 16'd0;
            sum_stage2_1 <= 16'd0;
        end

        // Stage 3: sum final pair to get product
        if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage2_0 + sum_stage2_1;
        end else begin
            mul_out_reg <= 16'd0;
        end

        // Output enable pipelined out at final stage
        mul_en_out <= mul_en_pipe[3];

        // Registered output mux: output product if enabled, else zero
        mul_out <= (mul_en_pipe[3]) ? mul_out_reg : 16'd0;
    end
end

endmodule