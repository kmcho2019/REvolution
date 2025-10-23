module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16,
    parameter STAGES     = DATA_WIDTH / STG_WIDTH
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg                o_en
);

    // Pipeline registers for operands
    reg [DATA_WIDTH-1:0] adda_pipe [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe [0:STAGES];

    // Pipeline registers for carry bits (one per stage plus initial zero)
    reg carry_pipe [0:STAGES];

    // Pipeline registers for sums per stage (STG_WIDTH bits each)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for enable signal
    reg i_en_pipe [0:STAGES];

    integer i;

    // Combinational wires for addition result of each stage
    wire [STG_WIDTH:0] stage_sum [0:STAGES-1];

    // Combinational addition for each stage
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : ADD_STAGES
            wire [STG_WIDTH-1:0] a_part = adda_pipe[stage][STG_WIDTH*(stage+1)-1 : STG_WIDTH*stage];
            wire [STG_WIDTH-1:0] b_part = addb_pipe[stage][STG_WIDTH*(stage+1)-1 : STG_WIDTH*stage];
            assign stage_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    // Sequential logic for pipelining and sum/carry registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipelines and outputs
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Pipeline operands and enable
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;

            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Initialize carry_in for stage 0
            carry_pipe[0] <= 1'b0;

            // Register sums and carry outs from each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= stage_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= stage_sum[i][STG_WIDTH];
            end

            // Assemble result from pipeline sums and final carry
            result <= {
                carry_pipe[STAGES],                      // MSB carry out
                sum_pipe[STAGES-1],                      // Highest stage sum
                sum_pipe[STAGES-2],
                sum_pipe[STAGES-3],
                sum_pipe[0]                              // Lowest stage sum
            };

            // Output enable signal indicates valid result
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule