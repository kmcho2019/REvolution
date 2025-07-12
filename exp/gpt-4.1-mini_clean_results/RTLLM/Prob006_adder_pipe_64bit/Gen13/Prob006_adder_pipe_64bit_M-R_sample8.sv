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
    localparam STG_BITS = 8;

    // Pipeline registers for operand slices, sum, carry, and enable
    reg [STG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_BITS-1:0] addb_pipe   [0:STAGES-1];
    reg [STG_BITS-1:0] sum_pipe    [0:STAGES-1];
    reg                carry_pipe  [0:STAGES];    // carry_pipe[0] = carry_in for stage 0
    reg                en_pipe     [0:STAGES];

    integer i;

    // Stage 0 registers operands and carry_in=0, computes sum and carry_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe[0] <= 0;
            addb_pipe[0] <= 0;
            sum_pipe[0]  <= 0;
            carry_pipe[0] <= 0;
            carry_pipe[1] <= 0;
            en_pipe[0]   <= 0;
            en_pipe[1]   <= 0;
        end else begin
            // Load inputs for stage 0
            adda_pipe[0] <= adda[7:0];
            addb_pipe[0] <= addb[7:0];
            carry_pipe[0] <= 1'b0;  // initial carry in zero
            en_pipe[0] <= i_en;

            // Calculate sum and carry out for stage 0
            {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];
            en_pipe[1] <= en_pipe[0];
        end
    end

    // Pipeline stages 1 to 7: each stage registers operands and carry_in, then computes sum and carry_out
    generate
        genvar stage;
        for(stage = 1; stage < STAGES; stage = stage + 1) begin : PIPE_STAGES
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    adda_pipe[stage] <= 0;
                    addb_pipe[stage] <= 0;
                    sum_pipe[stage]  <= 0;
                    carry_pipe[stage+1] <= 0;
                    en_pipe[stage+1] <= 0;
                end else begin
                    adda_pipe[stage] <= adda[stage*8 +: 8];
                    addb_pipe[stage] <= addb[stage*8 +: 8];
                    // Calculate sum and carry out
                    {carry_pipe[stage+1], sum_pipe[stage]} <= adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage];
                    en_pipe[stage+1] <= en_pipe[stage];
                end
            end
        end
    endgenerate

    // Output register: assemble full result and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else begin
            if (en_pipe[STAGES]) begin
                result <= {
                    carry_pipe[STAGES],      // MSB carry out
                    sum_pipe[7],
                    sum_pipe[6],
                    sum_pipe[5],
                    sum_pipe[4],
                    sum_pipe[3],
                    sum_pipe[2],
                    sum_pipe[1],
                    sum_pipe[0]
                };
                o_en <= 1'b1;
            end else begin
                result <= 0;
                o_en <= 0;
            end
        end
    end

endmodule