module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGES = 8;
    localparam WIDTH  = 8;

    // Pipeline registers for operand slices at each stage
    reg [WIDTH-1:0] adda_pipe [STAGES-1:0];
    reg [WIDTH-1:0] addb_pipe [STAGES-1:0];

    // Carry signals pipelined per stage
    reg carry_pipe [STAGES:0]; // carry_pipe[0] is carry-in = 0

    // Sum outputs per stage
    reg [WIDTH-1:0] sum_pipe [STAGES-1:0];

    // Enable signal pipeline
    reg [STAGES-1:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                sum_pipe[i] <= {WIDTH{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Initialize carry-in to 0 at pipeline stage 0
            carry_pipe[0] <= 1'b0;

            // Stage 0: register input slices and enable
            adda_pipe[0] <= adda[ 7: 0];
            addb_pipe[0] <= addb[ 7: 0];
            en_pipe[0] <= i_en;

            // Pipeline stages 1 to STAGES-1: register input slices and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*WIDTH +: WIDTH];
                addb_pipe[i] <= addb[i*WIDTH +: WIDTH];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sums and carry-out for each stage using registered inputs and carry-in
            for (i = 0; i < STAGES; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Pipeline output enable with one clock latency from last stage enable
            o_en <= en_pipe[STAGES-1];

            // Assemble output result when output enable is asserted
            if (en_pipe[STAGES-1]) begin
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[0]};
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule