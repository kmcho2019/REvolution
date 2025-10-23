module adder_pipe_64bit #(
    parameter STAGES = 8,          // Number of pipeline stages
    parameter WIDTH  = 8           // Width of each pipeline stage in bits
)(
    input                  clk,
    input                  rst_n,
    input                  i_en,
    input      [STAGES*WIDTH-1:0] adda,
    input      [STAGES*WIDTH-1:0] addb,
    output reg [STAGES*WIDTH:0]   result, // 65-bit result for 64-bit + carry
    output reg             o_en
);

    // Pipeline registers for operands, sums, carry, enable
    reg [WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg [WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg             carry_pipe  [0:STAGES];    // carry_pipe[0] = carry-in to stage 0
    reg             en_pipe     [0:STAGES];    // enables pipelined along stages

    integer i;

    // Sequential logic: pipeline shifting and addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                sum_pipe[i] <= {WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;

            result <= {(STAGES*WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 load operands only if i_en is asserted; else hold zero stage inputs
            if (i_en) begin
                adda_pipe[0] <= adda[WIDTH-1:0];
                addb_pipe[0] <= addb[WIDTH-1:0];
            end else begin
                adda_pipe[0] <= {WIDTH{1'b0}};
                addb_pipe[0] <= {WIDTH{1'b0}};
            end

            // Shift the operands through the pipeline (stage 1 to last)
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
            end

            // Initialize carry-in to stage 0 as zero when new addition starts
            carry_pipe[0] <= i_en ? 1'b0 : 1'b0;  // always zero carry-in at stage 0 input

            // Enable pipeline registers shift:
            // stage 0 enable asserted if i_en
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Perform additions stage-by-stage
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // When last stage enable is asserted, output result and enable flag
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sums from LSB to MSB plus final carry
                // sum_pipe[0] = bits [7:0], sum_pipe[7] = bits [63:56]
                result <= {
                    carry_pipe[STAGES],
                    sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                    sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8]
                };
            end else begin
                result <= {(STAGES*WIDTH+1){1'b0}};
            end
        end
    end

endmodule