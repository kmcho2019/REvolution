module adder_pipe_64bit(
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Pipeline registers for operand slices
    reg [15:0] adda_pipe [0:3];
    reg [15:0] addb_pipe [0:3];

    // Partial sums
    reg [15:0] sum_pipe [0:3];

    // Carry signals between stages
    reg carry_pipe [0:4];

    // Enable pipeline
    reg en_pipe [0:4];

    integer i;

    // Combinational sums with carry in
    wire [16:0] stage_sum [0:3];

    // Assign operands and carry_in to each stage adder
    assign stage_sum[0] = {1'b0, adda_pipe[0]} + {1'b0, addb_pipe[0]} + carry_pipe[0];
    assign stage_sum[1] = {1'b0, adda_pipe[1]} + {1'b0, addb_pipe[1]} + carry_pipe[1];
    assign stage_sum[2] = {1'b0, adda_pipe[2]} + {1'b0, addb_pipe[2]} + carry_pipe[2];
    assign stage_sum[3] = {1'b0, adda_pipe[3]} + {1'b0, addb_pipe[3]} + carry_pipe[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                adda_pipe[i] <= 16'd0;
                addb_pipe[i] <= 16'd0;
                sum_pipe[i]  <= 16'd0;
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[4] <= 1'b0;
            en_pipe[4] <= 1'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: capture input operands and initial carry_in=0
            adda_pipe[0] <= adda[15:0];
            addb_pipe[0] <= addb[15:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Stages 1 to 3: capture next 16-bit operand slices and carry-in from previous stage's carry-out
            for (i = 1; i < 4; i = i + 1) begin
                adda_pipe[i] <= adda[i*16 +: 16];
                addb_pipe[i] <= addb[i*16 +: 16];
                carry_pipe[i] <= stage_sum[i-1][16];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Register sums from combinational adders
            for (i = 0; i < 4; i = i + 1) begin
                sum_pipe[i] <= stage_sum[i][15:0];
            end

            // Register last carry out
            carry_pipe[4] <= stage_sum[3][16];

            // Propagate enable
            en_pipe[4] <= en_pipe[3];

            // Concatenate final 65-bit result: carry out + sums from MSB to LSB
            result <= {carry_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            o_en <= en_pipe[4];
        end
    end

endmodule