module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline stage registers for enable signal (5 stages total: input + 4 pipeline stages)
reg [4:0] mul_en_pipe;

// Stage 1: input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Stage 2: partial products (8 partial products, 16-bit each)
reg [15:0] pp [7:0];

// Stage 3: sum pairs of partial products -> 4 sums
reg [15:0] sum_stage3 [3:0];

// Stage 4: sum pairs of sums from stage 3 -> 2 sums
reg [15:0] sum_stage4 [1:0];

// Stage 5: final sum -> product output reg
reg [15:0] mul_out_reg;

// --------------------
// Stage 1: Sample inputs and enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// --------------------
// Stage 2: Generate partial products
// Multiplicand AND with each multiplier bit shifted accordingly
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1)
            pp[i] <= 16'd0;
    end else if (mul_en_pipe[0]) begin
        for (i = 0; i < 8; i = i + 1)
            pp[i] <= mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
    end else begin
        for (i = 0; i < 8; i = i + 1)
            pp[i] <= 16'd0;
    end
end

// --------------------
// Stage 3: Add pairs of partial products (8 -> 4 sums)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i = i + 1)
            sum_stage3[i] <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage3[0] <= pp[0] + pp[1];
        sum_stage3[1] <= pp[2] + pp[3];
        sum_stage3[2] <= pp[4] + pp[5];
        sum_stage3[3] <= pp[6] + pp[7];
    end else begin
        for (i = 0; i < 4; i = i + 1)
            sum_stage3[i] <= 16'd0;
    end
end

// --------------------
// Stage 4: Add pairs from previous sums (4 -> 2 sums)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage4[0] <= 16'd0;
        sum_stage4[1] <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        sum_stage4[0] <= sum_stage3[0] + sum_stage3[1];
        sum_stage4[1] <= sum_stage3[2] + sum_stage3[3];
    end else begin
        sum_stage4[0] <= 16'd0;
        sum_stage4[1] <= 16'd0;
    end
end

// --------------------
// Stage 5: Final addition to produce product output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        mul_out_reg <= sum_stage4[0] + sum_stage4[1];
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// --------------------
// Output enable synchronized with final product availability
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[4];
    end
end

// --------------------
// Output assignment: product output valid only when enable output is active
always @(*) begin
    mul_out = mul_en_out ? mul_out_reg : 16'd0;
end

endmodule