module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Pipeline depth and stage width
    localparam STAGES = 4;
    localparam WIDTH  = 16;

    // Stage registers for operands and i_en
    reg [63:0] adda_pipe [0:STAGES-1];
    reg [63:0] addb_pipe [0:STAGES-1];
    reg        i_en_pipe [0:STAGES];

    // Carry register per stage
    reg [STAGES:0] carry_pipe;

    // Sum per stage registers
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Input latching and i_en propagation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe[0] <= 64'b0;
            addb_pipe[0] <= 64'b0;
            i_en_pipe[0] <= 1'b0;
            carry_pipe <= 0;
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
                if(i > 0) begin
                    adda_pipe[i] <= 0;
                    addb_pipe[i] <= 0;
                end
            end
        end else begin
            // First pipeline stage input registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry in is zero

            // Pipeline through stages
            for (i = 0; i < STAGES; i = i + 1) begin
                if (i > 0) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
            end

            // Pipeline carry and sum calculation per stage
            // Each stage adds 16 bits plus carry_in
            // Sum and carry_out registered for next stage

            // Note: Doing in a sequential always block with combinational add for clean pipelining.
            // We'll compute combinationally for the current stage, then register results.

            // To avoid combinational loops, implement addition combinationally here,
            // then store results in registers.

            // So implement a small combinational block inside always for each stage add:

            // Using variables to hold intermediate add results
            reg [WIDTH:0] add_stage;

            // For each stage, perform addition
            // Register the sum and carry out for next clock cycle

            // Stage 0
            add_stage = {1'b0, adda_pipe[0][WIDTH-1:0]} + {1'b0, addb_pipe[0][WIDTH-1:0]} + carry_pipe[0];
            sum_pipe[0] <= add_stage[WIDTH-1:0];
            carry_pipe[1] <= add_stage[WIDTH];

            // Stage 1
            add_stage = {1'b0, adda_pipe[1][2*WIDTH-1:WIDTH]} + {1'b0, addb_pipe[1][2*WIDTH-1:WIDTH]} + carry_pipe[1];
            sum_pipe[1] <= add_stage[WIDTH-1:0];
            carry_pipe[2] <= add_stage[WIDTH];

            // Stage 2
            add_stage = {1'b0, adda_pipe[2][3*WIDTH-1:2*WIDTH]} + {1'b0, addb_pipe[2][3*WIDTH-1:2*WIDTH]} + carry_pipe[2];
            sum_pipe[2] <= add_stage[WIDTH-1:0];
            carry_pipe[3] <= add_stage[WIDTH];

            // Stage 3
            add_stage = {1'b0, adda_pipe[3][4*WIDTH-1:3*WIDTH]} + {1'b0, addb_pipe[3][4*WIDTH-1:3*WIDTH]} + carry_pipe[3];
            sum_pipe[3] <= add_stage[WIDTH-1:0];
            carry_pipe[4] <= add_stage[WIDTH];

            // Propagate i_en through pipeline
            i_en_pipe[1] <= i_en_pipe[0];
            i_en_pipe[2] <= i_en_pipe[1];
            i_en_pipe[3] <= i_en_pipe[2];
            i_en_pipe[4] <= i_en_pipe[3];

            // When the last stage is done, output result and o_en
            result <= {carry_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            o_en <= i_en_pipe[4];
        end
    end

endmodule