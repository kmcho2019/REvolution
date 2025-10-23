module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 4;
    localparam WIDTH  = 16;

    // Pipeline registers for operands per stage
    reg [63:0] adda_pipe [0:STAGES-1];
    reg [63:0] addb_pipe [0:STAGES-1];

    // Carry pipeline registers (one more than stages)
    reg [STAGES:0] carry_pipe;

    // Sum pipeline registers: 16 bits per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Enable pipeline registers (STAGES+1 depth)
    reg [STAGES:0] i_en_pipe;

    // Wires for combinational addition results per stage
    wire [WIDTH:0] add_stage [0:STAGES-1];

    // Combinational addition for each stage
    assign add_stage[0] = {1'b0, adda_pipe[0][WIDTH-1:0]} + {1'b0, addb_pipe[0][WIDTH-1:0]} + carry_pipe[0];
    assign add_stage[1] = {1'b0, adda_pipe[1][2*WIDTH-1:WIDTH]} + {1'b0, addb_pipe[1][2*WIDTH-1:WIDTH]} + carry_pipe[1];
    assign add_stage[2] = {1'b0, adda_pipe[2][3*WIDTH-1:2*WIDTH]} + {1'b0, addb_pipe[2][3*WIDTH-1:2*WIDTH]} + carry_pipe[2];
    assign add_stage[3] = {1'b0, adda_pipe[3][4*WIDTH-1:3*WIDTH]} + {1'b0, addb_pipe[3][4*WIDTH-1:3*WIDTH]} + carry_pipe[3];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                sum_pipe[i] <= {WIDTH{1'b0}};
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Input operands loaded into first pipeline stage
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;

            // Propagate operands through pipeline stages
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
            end

            // Pipeline carry signals and sums
            // Initial carry in is zero
            carry_pipe[0] <= 1'b0;

            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_stage[i][WIDTH-1:0];
                carry_pipe[i+1] <= add_stage[i][WIDTH];
            end

            // Pipeline enable signals
            for (i = 1; i <= STAGES; i = i + 1) begin
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Output the concatenated result and enable when pipeline done
            result <= {carry_pipe[STAGES], sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[0]};
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule