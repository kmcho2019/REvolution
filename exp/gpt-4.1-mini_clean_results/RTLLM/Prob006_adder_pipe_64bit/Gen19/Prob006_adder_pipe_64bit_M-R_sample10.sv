module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input  [DATA_WIDTH-1:0] adda,
    input  [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0]   result,   // DATA_WIDTH+1 bits for sum + carry out
    output                  o_en
);

    localparam STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands and enable (stage inputs)
    reg [DATA_WIDTH-1:0] adda_pipe [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe [0:STAGES];
    reg                  en_pipe   [0:STAGES];

    // Carry registers between stages (carry_pipe[0] is initial carry-in = 0)
    reg carry_pipe [0:STAGES];

    // Partial sums per stage (STG_WIDTH bits each)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Combinational wires for addition results at each stage (sum + carry out)
    wire [STG_WIDTH:0] adder_sum [0:STAGES-1];

    generate
        genvar stage;
        for(stage = 0; stage < STAGES; stage = stage + 1) begin : GEN_ADDER_STAGE
            wire [STG_WIDTH-1:0] a_part = adda_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            wire [STG_WIDTH-1:0] b_part = addb_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            assign adder_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            // Reset all pipeline registers
            for(i=0; i<=STAGES; i=i+1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for(i=0; i<STAGES; i=i+1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
        end else begin
            // Stage 0: Load inputs and set initial carry_in = 0
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0;

            // Compute sums and propagate carry for stage 0
            sum_pipe[0] <= adder_sum[0][STG_WIDTH-1:0];
            carry_pipe[1] <= adder_sum[0][STG_WIDTH];

            // Pipeline through subsequent stages
            for(i=1; i<STAGES; i=i+1) begin
                // Advance pipeline registers
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];

                // Compute sum and carry out for current stage
                sum_pipe[i] <= adder_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= adder_sum[i][STG_WIDTH];
            end

            // Advance the final pipeline stage registers to maintain timing for output
            adda_pipe[STAGES] <= adda_pipe[STAGES-1];
            addb_pipe[STAGES] <= addb_pipe[STAGES-1];
            en_pipe[STAGES]   <= en_pipe[STAGES-1];
        end
    end

    // Concatenate partial sums in order (lowest stage sum at LSB) to form full sum (excluding final carry)
    wire [DATA_WIDTH-1:0] sum_concat;
    generate
        genvar s;
        for(s=0; s<STAGES; s=s+1) begin : GEN_SUM_CONCAT
            assign sum_concat[s*STG_WIDTH +: STG_WIDTH] = sum_pipe[s];
        end
    endgenerate

    // Output signals assigned combinationally from final pipeline stage registers
    assign result = {carry_pipe[STAGES], sum_concat};
    assign o_en = en_pipe[STAGES];

endmodule