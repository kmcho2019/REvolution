module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH/STG_WIDTH;
localparam STG_BITS = $clog2(NUM_STAGES);

// Pipeline registers
reg [STG_WIDTH-1:0] a_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] b_pipe [0:NUM_STAGES-1];
reg carry_pipe [0:NUM_STAGES-2]; // carries between stages
reg [NUM_STAGES:0] en_pipe;      // enable pipeline

// Intermediate sums
wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

// Generate all pipeline stages
genvar i;
generate
    for (i = 0; i < NUM_STAGES; i = i + 1) begin : STAGES
        if (i == 0) begin
            // First stage has no carry in
            assign stage_sum[i] = {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]};
        end else begin
            // Subsequent stages include carry from previous stage
            assign stage_sum[i] = {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]} + 
                                 {STG_WIDTH'd0, carry_pipe[i-1]};
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < NUM_STAGES; j = j + 1) begin
            a_pipe[j] <= '0;
            b_pipe[j] <= '0;
            if (j < NUM_STAGES-1) carry_pipe[j] <= '0;
        end
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Pipeline input data
        for (integer k = 0; k < NUM_STAGES; k = k + 1) begin
            a_pipe[k] <= adda[k*STG_WIDTH +: STG_WIDTH];
            b_pipe[k] <= addb[k*STG_WIDTH +: STG_WIDTH];
        end

        // Pipeline carries
        for (integer m = 0; m < NUM_STAGES-1; m = m + 1) begin
            carry_pipe[m] <= stage_sum[m][STG_WIDTH];
        end

        // Compose final result
        result <= {stage_sum[NUM_STAGES-1][STG_WIDTH], 
                  stage_sum[NUM_STAGES-1][STG_WIDTH-1:0],
                  stage_sum[NUM_STAGES-2][STG_WIDTH-1:0],
                  stage_sum[NUM_STAGES-3][STG_WIDTH-1:0],
                  stage_sum[NUM_STAGES-4][STG_WIDTH-1:0]};

        // Pipeline enable signal
        en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};
        o_en <= en_pipe[NUM_STAGES];
    end
end

endmodule