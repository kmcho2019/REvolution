module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

// Pipeline stages count
localparam PIPE_STAGES = 4;

// Enable pipeline shift register
reg [PIPE_STAGES-1:0] mul_en_pipe;

// Stage 1: Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Stage 2: Partial products registers
reg [15:0] pp_reg [7:0];

// Stage 3: Partial sums registers
reg [15:0] sum_lvl1 [3:0]; // 4 sums from pairs of partial products
reg [15:0] sum_lvl2 [1:0]; // 2 sums from sum_lvl1
reg [15:0] sum_lvl3;       // final sum from sum_lvl2

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= {PIPE_STAGES{1'b0}};
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        for (i=0; i<8; i=i+1) pp_reg[i] <= 16'd0;
        for (i=0; i<4; i=i+1) sum_lvl1[i] <= 16'd0;
        for (i=0; i<2; i=i+1) sum_lvl2[i] <= 16'd0;
        sum_lvl3 <= 16'd0;
    end else begin
        // Pipeline enable shift
        mul_en_pipe <= {mul_en_pipe[PIPE_STAGES-2:0], mul_en_in};

        // Stage 1: latch inputs if enabled
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 2: partial products generation and register them
        // Each partial product = mul_a_reg shifted by bit index if mul_b_reg bit is set
        for (i=0; i<8; i=i+1) begin
            pp_reg[i] <= mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
        end

        // Stage 3: accumulate partial products in balanced tree and register sums
        // Level 1: sum pairs of partial products
        sum_lvl1[0] <= pp_reg[0] + pp_reg[1];
        sum_lvl1[1] <= pp_reg[2] + pp_reg[3];
        sum_lvl1[2] <= pp_reg[4] + pp_reg[5];
        sum_lvl1[3] <= pp_reg[6] + pp_reg[7];

        // Level 2: sum pairs of level 1 sums
        sum_lvl2[0] <= sum_lvl1[0] + sum_lvl1[1];
        sum_lvl2[1] <= sum_lvl1[2] + sum_lvl1[3];

        // Level 3: final sum of level 2 sums
        sum_lvl3 <= sum_lvl2[0] + sum_lvl2[1];
    end
end

// Output enable corresponds to last pipeline stage valid signal
assign mul_en_out = mul_en_pipe[PIPE_STAGES-1];

// Output product valid only when enable is high
assign mul_out = mul_en_out ? sum_lvl3 : 16'd0;

endmodule