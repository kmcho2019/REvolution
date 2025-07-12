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
    localparam WIDTH = 8; // 8-bit slices

    // Pipeline registers for input slices per stage
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry in and carry out per stage
    reg carry_in_pipe [0:STAGES-1];
    reg carry_out_pipe [0:STAGES-1];

    // Sum output per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Enable pipeline registers
    reg en_pipe [0:STAGES-1];

    integer i;

    // Combinational sum with carry per stage
    wire [WIDTH:0] sum_with_carry [0:STAGES-1];

    generate
        genvar stg;
        for (stg = 0; stg < STAGES; stg = stg + 1) begin : GEN_ADD_STAGE
            wire [WIDTH-1:0] a_in = (stg == 0) ? adda[stg*WIDTH +: WIDTH] : adda_pipe[stg];
            wire [WIDTH-1:0] b_in = (stg == 0) ? addb[stg*WIDTH +: WIDTH] : addb_pipe[stg];
            wire c_in = (stg == 0) ? 1'b0 : carry_in_pipe[stg];
            assign sum_with_carry[stg] = a_in + b_in + c_in;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                carry_in_pipe[i] <= 1'b0;
                carry_out_pipe[i] <= 1'b0;
                sum_pipe[i] <= {WIDTH{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 inputs and enable
            adda_pipe[0] <= adda[0*WIDTH +: WIDTH];
            addb_pipe[0] <= addb[0*WIDTH +: WIDTH];
            carry_in_pipe[0] <= 1'b0; // Carry-in zero for LSB stage
            en_pipe[0] <= i_en;

            // Register sum and carry out for stage 0
            sum_pipe[0] <= sum_with_carry[0][WIDTH-1:0];
            carry_out_pipe[0] <= sum_with_carry[0][WIDTH];

            // Pipeline stages 1 to 7
            for (i = 1; i < STAGES; i = i + 1) begin
                // Register operand slices
                adda_pipe[i] <= adda[i*WIDTH +: WIDTH];
                addb_pipe[i] <= addb[i*WIDTH +: WIDTH];
                // Register carry-in from previous stage's carry-out
                carry_in_pipe[i] <= carry_out_pipe[i-1];
                // Register enable signal
                en_pipe[i] <= en_pipe[i-1];
                // Register sum and carry-out from combinational addition of this stage
                sum_pipe[i] <= sum_with_carry[i][WIDTH-1:0];
                carry_out_pipe[i] <= sum_with_carry[i][WIDTH];
            end

            // Output enable after last stage pipeline register
            o_en <= en_pipe[STAGES-1];

            // Assemble final result when output is enabled
            if (en_pipe[STAGES-1]) begin
                result <= {carry_out_pipe[STAGES-1],
                           sum_pipe[7],
                           sum_pipe[6],
                           sum_pipe[5],
                           sum_pipe[4],
                           sum_pipe[3],
                           sum_pipe[2],
                           sum_pipe[1],
                           sum_pipe[0]};
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule