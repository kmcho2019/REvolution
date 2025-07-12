module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8,
    parameter STAGES = DATA_WIDTH / STG_WIDTH
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input       [DATA_WIDTH-1:0]  adda,
    input       [DATA_WIDTH-1:0]  addb,
    output reg  [DATA_WIDTH:0]    result,
    output reg                  o_en
);

    // Pipeline registers for input slices and sums
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] sum_pipe  [0:STAGES-1];
    reg carry_pipe [0:STAGES];       // carry signals, STAGES+1 entries
    reg en_pipe [0:STAGES];          // pipeline enable signals

    integer i;

    wire [STG_WIDTH:0] add_res [0:STAGES-1];

    // Combinational adders per stage
    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : GEN_ADD
            assign add_res[gi] = adda_pipe[gi] + addb_pipe[gi] + carry_pipe[gi];
        end
    endgenerate

    // Assemble final result from sums and final carry
    reg [DATA_WIDTH:0] sum_assembled;
    always @(*) begin
        sum_assembled = { (DATA_WIDTH+1){1'b0} };
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_assembled[i*STG_WIDTH +: STG_WIDTH] = sum_pipe[i];
        end
        sum_assembled[DATA_WIDTH] = carry_pipe[STAGES];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i]  <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: load input slices and carry-in 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Later stages: load slices and carry_in from previous stage carry_out
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= add_res[i-1][STG_WIDTH];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Capture partial sums
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_res[i][STG_WIDTH-1:0];
            end

            // Final carry out and enable
            carry_pipe[STAGES] <= add_res[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Output registered sum and enable
            result <= sum_assembled;
            o_en <= en_pipe[STAGES];
        end
    end

endmodule