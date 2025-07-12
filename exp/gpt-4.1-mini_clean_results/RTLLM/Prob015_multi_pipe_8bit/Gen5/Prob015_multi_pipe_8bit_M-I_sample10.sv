module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline register for input enable signal: 5-stage pipeline to match stages
reg [4:0] mul_en_pipe;

// Input operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Stage 2: Partial products (8 partial products, 16 bits each)
reg [15:0] pp [7:0];

// Stage 3: Sum pairs of partial products (4 sums)
reg [15:0] sum_stage3 [3:0];

// Stage 4: Sum pairs of sums (2 sums)
reg [15:0] sum_stage4 [1:0];

// Stage 5: Final sum (product)
reg [15:0] mul_out_reg;

// Input capture and enable pipeline
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
        // Capture operands only when input enable asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 2: Generate partial products, gated by mul_en_pipe[1]
// Each partial product: (mul_b_reg[i] ? mul_a_reg << i : 0)
// Operate only if mul_en_pipe[1] is asserted to reduce switching
integer i;
always @(posedge clk) begin
    if (!rst_n) begin
        for (i=0; i<8; i=i+1)
            pp[i] <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        for (i=0; i<8; i=i+1) begin
            if (mul_b_reg[i])
                pp[i] <= mul_a_reg << i;
            else
                pp[i] <= 16'd0;
        end
    end else begin
        // Clear partial products when not enabled to reduce glitching
        for (i=0; i<8; i=i+1)
            pp[i] <= 16'd0;
    end
end

// Stage 3: Sum pairs of partial products (pp[0]+pp[1], pp[2]+pp[3], pp[4]+pp[5], pp[6]+pp[7])
always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        sum_stage3[2] <= 16'd0;
        sum_stage3[3] <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        sum_stage3[0] <= pp[0] + pp[1];
        sum_stage3[1] <= pp[2] + pp[3];
        sum_stage3[2] <= pp[4] + pp[5];
        sum_stage3[3] <= pp[6] + pp[7];
    end else begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        sum_stage3[2] <= 16'd0;
        sum_stage3[3] <= 16'd0;
    end
end

// Stage 4: Sum pairs of sums (sum_stage3[0]+sum_stage3[1], sum_stage3[2]+sum_stage3[3])
always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage4[0] <= 16'd0;
        sum_stage4[1] <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        sum_stage4[0] <= sum_stage3[0] + sum_stage3[1];
        sum_stage4[1] <= sum_stage3[2] + sum_stage3[3];
    end else begin
        sum_stage4[0] <= 16'd0;
        sum_stage4[1] <= 16'd0;
    end
end

// Stage 5: Final product calculation (sum_stage4[0] + sum_stage4[1])
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_pipe[4]) begin
        mul_out_reg <= sum_stage4[0] + sum_stage4[1];
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Output enable signal from last stage of mul_en_pipe
always @(posedge clk) begin
    if (!rst_n)
        mul_en_out <= 1'b0;
    else
        mul_en_out <= mul_en_pipe[4];
end

// Registered output product when mul_en_out asserted; else zero
always @(posedge clk) begin
    if (!rst_n)
        mul_out <= 16'd0;
    else if (mul_en_out)
        mul_out <= mul_out_reg;
    else
        mul_out <= 16'd0;
end

endmodule