module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

// Parameters
// Let's pipeline the adder in 4 stages, each 16 bits.
// Stage 0: bits [15:0]
// Stage 1: bits [31:16]
// Stage 2: bits [47:32]
// Stage 3: bits [63:48]

// Registers to hold operands and enable signals at each stage
reg [63:0] adda_pipe0, addb_pipe0;
reg        en_pipe0;

reg [63:0] adda_pipe1, addb_pipe1;
reg        en_pipe1;

reg [63:0] adda_pipe2, addb_pipe2;
reg        en_pipe2;

reg [63:0] adda_pipe3, addb_pipe3;
reg        en_pipe3;

// Registers to hold partial sums and carry between pipeline stages
reg [15:0] sum_stage0;
reg        carry_stage0;

reg [15:0] sum_stage1;
reg        carry_stage1;

reg [15:0] sum_stage2;
reg        carry_stage2;

reg [15:0] sum_stage3;
reg        carry_stage3;

// Stage 0: latch inputs and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe0 <= 64'd0;
        addb_pipe0 <= 64'd0;
        en_pipe0   <= 1'b0;
    end else begin
        if (i_en) begin
            adda_pipe0 <= adda;
            addb_pipe0 <= addb;
        end
        en_pipe0 <= i_en;
    end
end

// Stage 0 addition (lower 16 bits)
wire [16:0] sum0 = {1'b0, adda_pipe0[15:0]} + {1'b0, addb_pipe0[15:0]};
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage0   <= 16'd0;
        carry_stage0 <= 1'b0;
    end else begin
        if (en_pipe0) begin
            sum_stage0   <= sum0[15:0];
            carry_stage0 <= sum0[16];
        end else begin
            sum_stage0   <= 16'd0;
            carry_stage0 <= 1'b0;
        end
    end
end

// Stage 1: latch operands and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
        en_pipe1   <= 1'b0;
    end else begin
        adda_pipe1 <= adda_pipe0;
        addb_pipe1 <= addb_pipe0;
        en_pipe1   <= en_pipe0;
    end
end

// Stage 1 addition (bits [31:16]) plus carry from stage0
wire [16:0] sum1 = {1'b0, adda_pipe1[31:16]} + {1'b0, addb_pipe1[31:16]} + carry_stage0;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1   <= 16'd0;
        carry_stage1 <= 1'b0;
    end else begin
        if (en_pipe1) begin
            sum_stage1   <= sum1[15:0];
            carry_stage1 <= sum1[16];
        end else begin
            sum_stage1   <= 16'd0;
            carry_stage1 <= 1'b0;
        end
    end
end

// Stage 2: latch operands and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        en_pipe2   <= 1'b0;
    end else begin
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        en_pipe2   <= en_pipe1;
    end
end

// Stage 2 addition (bits [47:32]) plus carry from stage1
wire [16:0] sum2 = {1'b0, adda_pipe2[47:32]} + {1'b0, addb_pipe2[47:32]} + carry_stage1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2   <= 16'd0;
        carry_stage2 <= 1'b0;
    end else begin
        if (en_pipe2) begin
            sum_stage2   <= sum2[15:0];
            carry_stage2 <= sum2[16];
        end else begin
            sum_stage2   <= 16'd0;
            carry_stage2 <= 1'b0;
        end
    end
end

// Stage 3: latch operands and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe3 <= 64'd0;
        addb_pipe3 <= 64'd0;
        en_pipe3   <= 1'b0;
    end else begin
        adda_pipe3 <= adda_pipe2;
        addb_pipe3 <= addb_pipe2;
        en_pipe3   <= en_pipe2;
    end
end

// Stage 3 addition (bits [63:48]) plus carry from stage2
wire [16:0] sum3 = {1'b0, adda_pipe3[63:48]} + {1'b0, addb_pipe3[63:48]} + carry_stage2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3   <= 16'd0;
        carry_stage3 <= 1'b0;
    end else begin
        if (en_pipe3) begin
            sum_stage3   <= sum3[15:0];
            carry_stage3 <= sum3[16];
        end else begin
            sum_stage3   <= 16'd0;
            carry_stage3 <= 1'b0;
        end
    end
end

// Final stage: assemble result and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en   <= 1'b0;
    end else begin
        if (en_pipe3) begin
            result <= {carry_stage3, sum_stage3, sum_stage2, sum_stage1, sum_stage0};
            o_en   <= 1'b1;
        end else begin
            result <= 65'd0;
            o_en   <= 1'b0;
        end
    end
end

endmodule