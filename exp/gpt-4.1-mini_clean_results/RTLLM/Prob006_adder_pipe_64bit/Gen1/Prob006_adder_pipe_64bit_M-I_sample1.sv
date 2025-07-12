module adder_pipe_64bit #(
    parameter STAGE_WIDTH = 16,
    parameter STAGES = 4
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input  [STAGE_WIDTH*STAGES-1:0] adda,
    input  [STAGE_WIDTH*STAGES-1:0] addb,
    output reg [STAGE_WIDTH*STAGES:0] result, // 65-bit output
    output reg              o_en
);

    // Local signals
    // Pipeline registers for inputs
    reg [STAGE_WIDTH*STAGES-1:0] adda_pipe   [0:STAGES];
    reg [STAGE_WIDTH*STAGES-1:0] addb_pipe   [0:STAGES];
    reg                          i_en_pipe   [0:STAGES];

    // Carry registers between stages
    reg carry_pipe   [0:STAGES]; // carry_pipe[0] is carry-in to stage 0 (always 0)

    // Partial sum registers for each stage
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Combinational wires for sum and carry outputs per stage
    reg [STAGE_WIDTH-1:0] sum_comb [0:STAGES-1];
    reg carry_comb [0:STAGES-1];

    integer i;

    // Combinational block to compute sum and carry for each pipeline stage
    always @(*) begin
        // carry_pipe[0] is always 0 for the first stage
        for (i = 0; i < STAGES; i = i + 1) begin
            // slice operands for stage i from the operands registered at pipeline stage i
            // adda_pipe[i] and addb_pipe[i] hold operands delayed i cycles
            sum_comb[i] = adda_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                        + addb_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                        + carry_pipe[i];
            // carry out is the MSB beyond the STAGE_WIDTH bits sum
            carry_comb[i] = (adda_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                           + addb_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                           + carry_pipe[i]) >> STAGE_WIDTH;
        end
    end

    // Sequential pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {(STAGE_WIDTH*STAGES){1'b0}};
                addb_pipe[i] <= {(STAGE_WIDTH*STAGES){1'b0}};
                i_en_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;

            result <= {(STAGE_WIDTH*STAGES+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Register inputs and enable into pipeline stage 0
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // carry-in zero at first stage

            // For stages 1..STAGES: propagate registered inputs and enable signals
            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
                // carry_pipe[i] updated with carry_out from previous stage combinational calc
                if (i <= STAGES - 1)
                    carry_pipe[i] <= carry_comb[i-1];
                else
                    carry_pipe[i] <= carry_pipe[i]; // retain final carry until next clock or reset
            end

            // Update sum registers with combinational sums computed from pipeline stage i
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_comb[i];
            end

            // Assemble result from the partial sums and last carry
            result <= {carry_pipe[STAGES], sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[0]};
            // Note: sum_pipe order concatenation (MSB first to LSB last)
            // This is equivalent to:
            // result = {carry_pipe[STAGES],
            //           sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]}
            // for STAGES=4

            // Output enable delayed by STAGES cycles to indicate result valid
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule