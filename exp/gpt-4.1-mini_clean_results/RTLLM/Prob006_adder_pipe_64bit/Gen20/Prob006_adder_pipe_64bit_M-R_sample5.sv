module adder_pipe_64bit (
    input                 clk,
    input                 rst_n,
    input                 i_en,
    input      [63:0]     adda,
    input      [63:0]     addb,
    output reg [64:0]     result,
    output reg            o_en
);

    parameter DATA_WIDTH = 64;
    parameter STG_WIDTH  = 16;
    parameter STAGES     = DATA_WIDTH / STG_WIDTH; // 4

    // Pipeline registers for inputs and enable
    reg [DATA_WIDTH-1:0] adda_pipe [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe [0:STAGES];
    reg                  en_pipe   [0:STAGES];

    // Partial sums per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Carry out signals per stage (carry_pipe[0] is initial carry-in 0)
    reg carry_pipe [0:STAGES];

    integer i;

    // Combinational sums per stage: sum of 16-bit slice + carry_in
    wire [STG_WIDTH:0] adder_sum [0:STAGES-1];

    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_adder_stages
            wire [STG_WIDTH-1:0] a_part = adda_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            wire [STG_WIDTH-1:0] b_part = addb_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            assign adder_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
                carry_pipe[i]<= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift pipeline inputs and enable signals
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry-in zero

            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
            end

            // Update partial sums and carry-outs for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= adder_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= adder_sum[i][STG_WIDTH];
            end

            // Update output enable with pipeline delayed i_en
            o_en <= en_pipe[STAGES];

            // Output concatenation of partial sums and final carry
            if (en_pipe[STAGES]) begin
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4]};
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end
endmodule