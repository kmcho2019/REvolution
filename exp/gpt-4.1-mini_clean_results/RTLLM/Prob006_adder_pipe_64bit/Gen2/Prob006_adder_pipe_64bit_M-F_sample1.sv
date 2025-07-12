module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                   o_en
);

    // Number of pipeline stages = DATA_WIDTH / STG_WIDTH
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Stage registers for inputs A and B slices
    reg [STG_WIDTH-1:0] stageA [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] stageB [0:NUM_STAGES-1];

    // Carry registers between stages
    reg carry [0:NUM_STAGES];

    // Sum registers for each stage (STG_WIDTH + 1 bits to hold carry out)
    reg [STG_WIDTH:0] sum [0:NUM_STAGES-1];

    // Pipeline registers for input enable delayed through stages
    reg [NUM_STAGES:0] i_en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                stageA[i] <= {STG_WIDTH{1'b0}};
                stageB[i] <= {STG_WIDTH{1'b0}};
                sum[i]    <= {(STG_WIDTH+1){1'b0}};
            end
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            i_en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Stage 0 input latch and addition
            if (i_en) begin
                stageA[0] <= adda[STG_WIDTH-1:0];
                stageB[0] <= addb[STG_WIDTH-1:0];
                carry[0]  <= 1'b0; // Initial carry-in zero for first stage
            end
            sum[0] <= {1'b0, stageA[0]} + {1'b0, stageB[0]} + carry[0];
            carry[1] <= sum[0][STG_WIDTH];

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (i_en_pipe[i]) begin
                    stageA[i] <= adda[(i+1)*STG_WIDTH-1 : i*STG_WIDTH];
                    stageB[i] <= addb[(i+1)*STG_WIDTH-1 : i*STG_WIDTH];
                end
                sum[i] <= {1'b0, stageA[i]} + {1'b0, stageB[i]} + carry[i];
                carry[i+1] <= sum[i][STG_WIDTH];
            end

            // Assign output result when final stage output is valid
            if (i_en_pipe[NUM_STAGES]) begin
                result <= {carry[NUM_STAGES], 
                           sum[NUM_STAGES-1][STG_WIDTH-1:0]};
                // Concatenate all sums lower bits
                for (i = NUM_STAGES-1; i > 0; i = i -1) begin
                    result = {result[DATA_WIDTH:STG_WIDTH], sum[i-1][STG_WIDTH-1:0], result[STG_WIDTH-1:0]};
                end
            end

            // Output enable when final stage valid
            o_en <= i_en_pipe[NUM_STAGES];
        end
    end

endmodule