module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline depth: 5 stages (input capture, partial products, add stage 1, add stage 2, output stage)

// Pipeline registers for enable signal and operands
reg [4:0] mul_en_pipe;
reg [7:0] mul_a_pipe [0:1];
reg [7:0] mul_b_pipe [0:1];

// Partial products stage registers: 8 partial products (16-bit)
reg [15:0] pp_reg [0:7];

// Intermediate sums stage 1 registers: 4 sums (16-bit)
reg [15:0] sum_stage1 [0:3];

// Intermediate sums stage 2 registers: 2 sums (16-bit)
reg [15:0] sum_stage2 [0:1];

// Final sum register (16-bit)
reg [15:0] final_sum_reg;

// Stage 0: Sample inputs and mul_en_in
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'b0;
        mul_a_pipe[0] <= 8'd0;
        mul_b_pipe[0] <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_pipe[0] <= mul_a;
            mul_b_pipe[0] <= mul_b;
        end
    end
end

// Stage 1: Generate partial products and pipe them
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            pp_reg[i] <= 16'd0;
        end
        mul_a_pipe[1] <= 8'd0;
        mul_b_pipe[1] <= 8'd0;
    end else if (mul_en_pipe[0]) begin
        // Generate partial products: pp[i] = (mul_b[i] ? mul_a << i : 0)
        for (i = 0; i < 8; i = i + 1) begin
            pp_reg[i] <= (mul_b_pipe[0][i]) ? ( {8'd0, mul_a_pipe[0]} << i ) : 16'd0;
        end
        mul_a_pipe[1] <= mul_a_pipe[0];
        mul_b_pipe[1] <= mul_b_pipe[0];
    end else begin
        for (i = 0; i < 8; i = i + 1) begin
            pp_reg[i] <= 16'd0;
        end
        mul_a_pipe[1] <= 8'd0;
        mul_b_pipe[1] <= 8'd0;
    end
end

// Stage 2: Sum pairs of partial products: (pp0+pp1), (pp2+pp3), (pp4+pp5), (pp6+pp7)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i = i + 1) begin
            sum_stage1[i] <= 16'd0;
        end
    end else if (mul_en_pipe[1]) begin
        sum_stage1[0] <= pp_reg[0] + pp_reg[1];
        sum_stage1[1] <= pp_reg[2] + pp_reg[3];
        sum_stage1[2] <= pp_reg[4] + pp_reg[5];
        sum_stage1[3] <= pp_reg[6] + pp_reg[7];
    end else begin
        for (i = 0; i < 4; i = i + 1) begin
            sum_stage1[i] <= 16'd0;
        end
    end
end

// Stage 3: Sum pairs of sums from stage 2: (sum_stage1[0]+sum_stage1[1]), (sum_stage1[2]+sum_stage1[3])
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
        sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
    end else begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
    end
end

// Stage 4: Final sum (sum_stage2[0] + sum_stage2[1])
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum_reg <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        final_sum_reg <= sum_stage2[0] + sum_stage2[1];
    end else begin
        final_sum_reg <= 16'd0;
    end
end

// Output enable at stage 4 (pipeline register bit 4)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[4];
    end
end

// Output mux: assign product only if enabled, else zero
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_pipe[4]) begin
        mul_out <= final_sum_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule