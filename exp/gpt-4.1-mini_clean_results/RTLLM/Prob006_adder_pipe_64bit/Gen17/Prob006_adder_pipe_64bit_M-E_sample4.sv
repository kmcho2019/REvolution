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
    localparam SEG_WIDTH = 8;

    // Pipeline registers for operands per stage
    reg [SEG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [SEG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry registers between stages
    reg carry_pipe [0:STAGES];  // carry_pipe[0] is first stage carry-in (always 0)
    
    // Sum pipeline registers per stage
    reg [SEG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline for input enable signal
    reg en_pipe [0:STAGES];

    integer i;

    // Stage 0: latch inputs and initial carry_in = 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<STAGES; i=i+1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Input stage latching
            if (i_en) begin
                for (i=0; i<STAGES; i=i+1) begin
                    adda_pipe[i] <= adda[i*SEG_WIDTH +: SEG_WIDTH];
                    addb_pipe[i] <= addb[i*SEG_WIDTH +: SEG_WIDTH];
                end
            end

            // Propagate input enable signal through pipeline stages
            en_pipe[0] <= i_en;
            // Carry-in for first stage always zero
            carry_pipe[0] <= 1'b0;

            // From stage 0 to 7: compute sums and carry outs
            for (i=0; i<STAGES; i=i+1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= 0;
                    carry_pipe[i+1] <= 0;
                end
            end

            // Shift enable signal for next stage
            for (i=1; i<=STAGES; i=i+1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Output stage: assemble result and valid signal
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sum pieces in order from MSB segment [7] down to LSB segment [0]
                result <= {carry_pipe[STAGES], 
                           sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            end else begin
                result <= 65'b0;
            end
        end
    end
endmodule