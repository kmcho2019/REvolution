module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters
    localparam STAGES = 16;    // 16 stages, each 4 bits
    localparam WIDTH  = 4;     // 4 bits per stage

    // Pipeline registers
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg             carry_pipe[0:STAGES];      // carry_pipe[0] is carry-in to stage 0
    reg [WIDTH-1:0] sum_pipe  [0:STAGES-1];
    reg             en_pipe   [0:STAGES];      // enable signals pipeline

    integer i;

    // Combinational sums and carry out
    wire [WIDTH-1:0] sum_comb  [0:STAGES-1];
    wire             carry_out_comb [0:STAGES-1];

    // Compute sums and carry-out for each stage combinationally
    genvar s;
    generate
        for (s = 0; s < STAGES; s = s + 1) begin : stage_add
            assign {carry_out_comb[s], sum_comb[s]} = adda_pipe[s] + addb_pipe[s] + carry_pipe[s];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
                en_pipe[i]   <= 0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 0;
            end
            o_en <= 0;
            result <= 0;
        end else begin
            // Stage 0 input loading
            if (i_en) begin
                adda_pipe[0] <= adda[ 3:0];
                addb_pipe[0] <= addb[ 3:0];
                en_pipe[0]   <= 1'b1;
                carry_pipe[0] <= 1'b0;       // carry-in zero for first stage
            end else begin
                // If no valid input, disable stage 0 and zero carry_in
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
                en_pipe[0] <= 1'b0;
                carry_pipe[0] <= 1'b0;
            end

            // Propagate pipeline registers for stages 1..STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
                carry_pipe[i] <= carry_out_comb[i-1];   // carry-out of prev stage is carry-in to this stage
            end

            // Register sum_pipe only if stage is enabled, else hold previous sum
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_pipe[i])
                    sum_pipe[i] <= sum_comb[i];
                else
                    sum_pipe[i] <= sum_pipe[i];
            end

            // carry_pipe[STAGES] is carry-out of last stage, registered on current clock
            carry_pipe[STAGES] <= en_pipe[STAGES-1] ? carry_out_comb[STAGES-1] : carry_pipe[STAGES];

            // Propagate enable signal to pipeline output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assign output enable and result
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sum pieces in ascending address order, sum_pipe[0] is bits [3:0]
                result <= { carry_pipe[STAGES],
                            sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                            sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8],
                            sum_pipe[STAGES-9], sum_pipe[STAGES-10], sum_pipe[STAGES-11], sum_pipe[STAGES-12],
                            sum_pipe[STAGES-13], sum_pipe[STAGES-14], sum_pipe[STAGES-15], sum_pipe[STAGES-16]
                          };
                // sum_pipe[STAGES-16] is sum_pipe[0]
            end else begin
                result <= 0;
            end
        end
    end

endmodule