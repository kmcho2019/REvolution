module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 8;
    localparam WIDTH = 8;

    // Pipeline registers
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg [WIDTH-1:0] sum_pipe  [0:STAGES-1];
    reg             carry_pipe[0:STAGES];  // carry_pipe[0] is carry in for stage 0
    reg             en_pipe   [0:STAGES];

    integer i;

    // Wires for sum+carry calculation per stage
    wire [WIDTH:0] sum_carry [0:STAGES-1];
    genvar idx;
    generate
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : SUM_CARRY_GEN
            assign sum_carry[idx] = adda_pipe[idx] + addb_pipe[idx] + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i]   <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Load new operands and enable stage 0 if i_en asserted
            if (i_en) begin
                // Split 64-bit inputs into 8-bit slices for stage 0
                for (i = 0; i < STAGES; i = i + 1) begin
                    // Delay loading slices to pipeline stages, we load all slices into pipe in one go for clarity
                    // But to keep pipeline consistent, load all slices here directly into registers (simplified)
                    adda_pipe[i] <= adda[i*WIDTH +: WIDTH];
                    addb_pipe[i] <= addb[i*WIDTH +: WIDTH];
                end
                carry_pipe[0] <= 1'b0; // initial carry-in zero at stage 0
                en_pipe[0] <= 1'b1;
            end else begin
                // Shift operands down the pipeline
                for (i = STAGES-1; i > 0; i = i - 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                    sum_pipe[i]  <= sum_pipe[i-1];
                    en_pipe[i]   <= en_pipe[i-1];
                    carry_pipe[i] <= carry_pipe[i-1];
                end
                // Hold stage 0 registers stable when no new input
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
                sum_pipe[0]  <= sum_pipe[0];
                en_pipe[0]   <= 1'b0;
                carry_pipe[0] <= carry_pipe[0];
            end

            // Compute sum and carry for all stages combinationally and register sums/carry_out
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_carry[i][WIDTH-1:0];
                carry_pipe[i+1] <= sum_carry[i][WIDTH];
            end

            // Output enable and result valid at final pipeline stage
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[0]};
            end
        end
    end

endmodule