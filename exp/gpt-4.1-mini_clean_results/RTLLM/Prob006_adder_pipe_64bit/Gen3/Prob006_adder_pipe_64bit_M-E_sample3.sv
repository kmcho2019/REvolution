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

    // Pipeline registers for operand slices per stage
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry pipeline registers (carry in to each stage)
    reg carry_pipe [0:STAGES];

    // Partial sum pipeline registers
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline enable signals for input enable propagation
    reg i_en_pipe [0:STAGES];

    integer i;

    // Combinational addition result wires per stage (WIDTH+1 bits for carry)
    wire [WIDTH:0] add_stage_res [0:STAGES-1];

    // Compute addition per stage combinationally
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : adder_stage
            assign add_stage_res[idx] = {1'b0, adda_pipe[idx]} + {1'b0, addb_pipe[idx]} + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                sum_pipe[i]  <= {WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            i_en_pipe[STAGES] <= 1'b0;
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: register inputs and initial carry = 0
            adda_pipe[0] <= adda[15:0];
            addb_pipe[0] <= addb[15:0];
            carry_pipe[0] <= 1'b0;
            i_en_pipe[0] <= i_en;

            // Subsequent stages: register operand slices and carry from previous stage's carry-out
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[(i*WIDTH)+:WIDTH];
                addb_pipe[i] <= addb[(i*WIDTH)+:WIDTH];
                carry_pipe[i] <= add_stage_res[i-1][WIDTH];  // carry out from prior stage
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Compute and register sums at each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_stage_res[i][WIDTH-1:0];
            end

            // Last carry_out register
            carry_pipe[STAGES] <= add_stage_res[STAGES-1][WIDTH];

            // Propagate input enable through final stage
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Assemble the 65-bit result from partial sums and last carry
            result <= {carry_pipe[STAGES], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};

            // Output enable driven by the delayed input enable after pipeline
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule