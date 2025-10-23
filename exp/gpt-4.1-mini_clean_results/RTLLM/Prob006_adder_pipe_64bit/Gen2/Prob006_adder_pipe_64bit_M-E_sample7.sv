module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

    localparam STAGES = 8;         // 8 pipeline stages
    localparam CHUNK = 8;          // bits per stage

    // Pipeline registers for inputs of each stage (chunk of 8 bits)
    reg [CHUNK-1:0] adda_pipe [0:STAGES-1];
    reg [CHUNK-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for carry signals between stages (1-bit)
    reg carry_pipe [0:STAGES];  // carry_pipe[0] is carry-in (0), carry_pipe[STAGES] is final carry-out

    // Pipeline registers for sum outputs of each stage
    reg [CHUNK-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register for input enable signal
    reg [STAGES-1:0] en_pipe;

    integer i;

    // Initialize carry_in at stage 0 as zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            carry_pipe[0] <= 1'b0;
            o_en <= 1'b0;
            result <= 0;
            en_pipe <= 0;

            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i+1] <= 0;
            end
        end else begin
            // Pipeline input enable
            en_pipe <= {en_pipe[STAGES-2:0], i_en};

            // Stage 0: latch inputs when i_en is high, else hold zeros
            if (i_en) begin
                adda_pipe[0] <= adda[CHUNK-1:0];
                addb_pipe[0] <= addb[CHUNK-1:0];
            end else begin
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
            end
            carry_pipe[0] <= 1'b0; // initial carry-in is zero

            // For stages 1 to STAGES-1, latch inputs from previous stage when previous enable is high
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[ (i+1)*CHUNK -1 : i*CHUNK ];
                    addb_pipe[i] <= addb[ (i+1)*CHUNK -1 : i*CHUNK ];
                end else begin
                    adda_pipe[i] <= 0;
                    addb_pipe[i] <= 0;
                end
            end

            // Perform addition for each stage when previous stage's enable is high
            for (i = 0; i < STAGES; i = i + 1) begin
                if (i == 0) begin
                    // Stage 0 uses i_en as valid signal
                    if (i_en) begin
                        {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                    end else begin
                        sum_pipe[i] <= 0;
                        carry_pipe[i+1] <= 0;
                    end
                end else begin
                    // Subsequent stages use en_pipe[i-1]
                    if (en_pipe[i-1]) begin
                        {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                    end else begin
                        sum_pipe[i] <= 0;
                        carry_pipe[i+1] <= 0;
                    end
                end
            end

            // Output enable is delayed version of i_en by STAGES cycles
            o_en <= en_pipe[STAGES-1];

            // When output enable is high, assemble full result
            if (en_pipe[STAGES-1]) begin
                // Concatenate sum chunks and final carry-out
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[STAGES-8]
                          };
                // Note: STAGES=8, so indexing from 7 downto 0 is correct
            end else begin
                result <= 0;
            end
        end
    end

endmodule