module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
localparam PIPELINE_STAGES = 3;

// Define the width of the adder
localparam ADDER_WIDTH = 64;

// Define the width of the result
localparam RESULT_WIDTH = ADDER_WIDTH + 1;

// Define the width of the input enable signal
localparam I_EN_WIDTH = 1;

// Define the internal signals
reg [ADDER_WIDTH-1:0] adda_pipe [PIPELINE_STAGES-1:0];
reg [ADDER_WIDTH-1:0] addb_pipe [PIPELINE_STAGES-1:0];
reg [I_EN_WIDTH-1:0] i_en_pipe [PIPELINE_STAGES-1:0];
reg [RESULT_WIDTH-1:0] result_pipe;

// Define the carry signals
reg [PIPELINE_STAGES-1:0] carry;

// Define the internal output enable signal
reg o_en_pipe;

// Initialize the pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the pipeline registers
        for (int i = 0; i < PIPELINE_STAGES-1; i++) begin
            adda_pipe[i] <= '0;
            addb_pipe[i] <= '0;
            i_en_pipe[i] <= '0;
        end
        result_pipe <= '0;
        o_en_pipe <= '0;
    end else if (i_en) begin
        // Shift the pipeline registers
        for (int i = PIPELINE_STAGES-2; i >= 0; i--) begin
            adda_pipe[i+1] <= adda_pipe[i];
            addb_pipe[i+1] <= addb_pipe[i];
            i_en_pipe[i+1] <= i_en_pipe[i];
        end
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        i_en_pipe[0] <= i_en;
    end
end

// Calculate the sum and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the carry signals
        for (int i = 0; i < PIPELINE_STAGES; i++) begin
            carry[i] <= '0;
        end
        result_pipe <= '0;
    end else if (i_en_pipe[PIPELINE_STAGES-2]) begin
        // Calculate the sum and carry
        reg [RESULT_WIDTH-1:0] sum;
        reg [RESULT_WIDTH-1:0] carry_tmp;
        sum[0] = adda_pipe[PIPELINE_STAGES-1][0] ^ addb_pipe[PIPELINE_STAGES-1][0] ^ carry[PIPELINE_STAGES-1];
        carry_tmp[0] = (adda_pipe[PIPELINE_STAGES-1][0] & addb_pipe[PIPELINE_STAGES-1][0]) | (adda_pipe[PIPELINE_STAGES-1][0] & carry[PIPELINE_STAGES-1]) | (addb_pipe[PIPELINE_STAGES-1][0] & carry[PIPELINE_STAGES-1]);
        for (int i = 1; i < ADDER_WIDTH; i++) begin
            sum[i] = adda_pipe[PIPELINE_STAGES-1][i] ^ addb_pipe[PIPELINE_STAGES-1][i] ^ carry_tmp[i-1];
            carry_tmp[i] = (adda_pipe[PIPELINE_STAGES-1][i] & addb_pipe[PIPELINE_STAGES-1][i]) | (adda_pipe[PIPELINE_STAGES-1][i] & carry_tmp[i-1]) | (addb_pipe[PIPELINE_STAGES-1][i] & carry_tmp[i-1]);
        end
        sum[RESULT_WIDTH-1] = carry_tmp[ADDER_WIDTH-1];
        result_pipe <= sum;
    end
end

// Update the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_pipe <= '0;
    end else if (i_en_pipe[PIPELINE_STAGES-1]) begin
        o_en_pipe <= '1;
    end else if (!i_en_pipe[PIPELINE_STAGES-1]) begin
        o_en_pipe <= '0;
    end
end

// Assign the output signals
assign result = result_pipe;
assign o_en = o_en_pipe;

endmodule