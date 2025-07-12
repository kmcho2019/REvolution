module adder_pipe_64bit(
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_BITS = 8;
    localparam STG_NUM  = 64 / STG_BITS; // 8 stages

    // Registered inputs and enable for stage 0
    reg [63:0] adda_reg, addb_reg;
    reg        i_en_reg;

    // Pipeline registers for sum slices and carry signals per stage
    reg [STG_BITS-1:0] sum_pipe [0:STG_NUM-1];
    reg                carry_pipe [0:STG_NUM]; // carry_pipe[0] is carry-in to stage 0

    // Enable pipeline to track valid data through stages
    reg [STG_NUM-1:0]  en_pipe;

    integer i;

    // At reset, clear registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'b0;
            addb_reg <= 64'b0;
            i_en_reg <= 1'b0;

            for (i = 0; i < STG_NUM; i = i + 1) begin
                sum_pipe[i] <= 0;
                en_pipe[i] <= 0;
                carry_pipe[i] <= 0;
            end
            carry_pipe[STG_NUM] <= 0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Register inputs and enable at stage 0
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= i_en;

            // Shift enable pipeline: insert current i_en_reg at stage 0
            en_pipe <= {en_pipe[STG_NUM-2:0], i_en_reg};

            // Propagate carry signals and compute stage sums
            // Stage 0 uses carry_pipe[0] = 0 when new input arrives (on i_en_reg)
            // Otherwise carry_pipe[0] keeps zero (no initial carry-in)
            carry_pipe[0] <= i_en_reg ? 1'b0 : carry_pipe[0];

            // For each stage compute sum and carry-out
            for (i = 0; i < STG_NUM; i = i + 1) begin
                if (i == 0) begin
                    // Slice operands for stage 0 from registered inputs
                    wire [STG_BITS-1:0] a0 = adda_reg[STG_BITS-1:0];
                    wire [STG_BITS-1:0] b0 = addb_reg[STG_BITS-1:0];
                    wire [STG_BITS:0] s0 = a0 + b0 + carry_pipe[0];
                    if (en_pipe[0]) begin
                        sum_pipe[0] <= s0[STG_BITS-1:0];
                        carry_pipe[1] <= s0[STG_BITS];
                    end
                end else begin
                    // Slice operands for stage i from registered inputs
                    wire [STG_BITS-1:0] ai = adda_reg[(i+1)*STG_BITS-1 -: STG_BITS];
                    wire [STG_BITS-1:0] bi = addb_reg[(i+1)*STG_BITS-1 -: STG_BITS];
                    wire [STG_BITS:0] si = ai + bi + carry_pipe[i];
                    if (en_pipe[i]) begin
                        sum_pipe[i] <= si[STG_BITS-1:0];
                        carry_pipe[i+1] <= si[STG_BITS];
                    end
                end
            end

            // When last stage enable is asserted, output result and o_en
            if (en_pipe[STG_NUM-1]) begin
                // Concatenate all sum_pipe from MSB to LSB and final carry out
                result <= {carry_pipe[STG_NUM],
                           sum_pipe[STG_NUM-1], sum_pipe[STG_NUM-2], sum_pipe[STG_NUM-3], sum_pipe[STG_NUM-4],
                           sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'b0;
                o_en <= 1'b0;
            end
        end
    end

endmodule