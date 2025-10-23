module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Configuration parameters
parameter PIPELINE_DEPTH = 4;

// Pipeline stage 1: Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg en_pipe1;

// Partial products generation
wire [15:0] pp [0:7];
generate
    genvar i;
    for (i=0; i<8; i=i+1) begin : pp_gen
        assign pp[i] = mul_b_reg[i] ? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Pipeline stage 2: First level additions
reg [15:0] sum_stage2 [0:3];
reg en_pipe2;

// Pipeline stage 3: Second level additions
reg [15:0] sum_stage3 [0:1];
reg en_pipe3;

// Pipeline stage 4: Final addition
reg [15:0] sum_stage4;
reg en_pipe4;

// Stage 1: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_pipe1 <= 1'b0;
    end else begin
        en_pipe1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 2: First level of additions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'b0;
        sum_stage2[1] <= 16'b0;
        sum_stage2[2] <= 16'b0;
        sum_stage2[3] <= 16'b0;
        en_pipe2 <= 1'b0;
    end else begin
        en_pipe2 <= en_pipe1;
        if (en_pipe1) begin
            sum_stage2[0] <= pp[0] + pp[1];
            sum_stage2[1] <= pp[2] + pp[3];
            sum_stage2[2] <= pp[4] + pp[5];
            sum_stage2[3] <= pp[6] + pp[7];
        end
    end
end

// Stage 3: Second level additions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'b0;
        sum_stage3[1] <= 16'b0;
        en_pipe3 <= 1'b0;
    end else begin
        en_pipe3 <= en_pipe2;
        if (en_pipe2) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end
    end
end

// Stage 4: Final addition and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage4 <= 16'b0;
        en_pipe4 <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        en_pipe4 <= en_pipe3;
        if (en_pipe3) begin
            sum_stage4 <= sum_stage3[0] + sum_stage3[1];
        end
        
        mul_en_out <= en_pipe4;
        mul_out <= sum_stage4;
    end
end

endmodule