module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16  // Stage width must divide DATA_WIDTH evenly
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

// Validate parameters
initial begin
    if (DATA_WIDTH % STG_WIDTH != 0) begin
        $error("STG_WIDTH must divide DATA_WIDTH evenly");
        $finish;
    end
end

// Pipeline registers
reg [STG_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];
reg [STG_WIDTH:0] sum_pipe [0:NUM_STAGES-1];  // Includes carry out
reg carry_pipe [0:NUM_STAGES-2];  // Carry between stages
reg en_pipe [0:NUM_STAGES];

// Combinational additions for each stage
wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

generate
    genvar i;
    for (i = 0; i < NUM_STAGES; i = i + 1) begin : stage_adders
        if (i == 0) begin
            // First stage has no carry in
            assign stage_sum[i] = adda_pipe[i] + addb_pipe[i];
        end else begin
            // Subsequent stages include carry from previous stage
            assign stage_sum[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i-1];
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < NUM_STAGES; j = j + 1) begin
            adda_pipe[j] <= '0;
            addb_pipe[j] <= '0;
            sum_pipe[j] <= '0;
            en_pipe[j] <= 1'b0;
            if (j < NUM_STAGES-1) carry_pipe[j] <= 1'b0;
        end
        
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        for (integer k = 0; k < NUM_STAGES; k = k + 1) begin
            adda_pipe[k] <= adda[k*STG_WIDTH +: STG_WIDTH];
            addb_pipe[k] <= addb[k*STG_WIDTH +: STG_WIDTH];
        end
        
        // Pipeline the sums and carries
        for (integer m = 0; m < NUM_STAGES; m = m + 1) begin
            sum_pipe[m] <= stage_sum[m];
            if (m < NUM_STAGES-1) begin
                carry_pipe[m] <= stage_sum[m][STG_WIDTH];
            end
        end
        
        // Pipeline the enable signal
        en_pipe[0] <= i_en;
        for (integer n = 1; n <= NUM_STAGES; n = n + 1) begin
            en_pipe[n] <= en_pipe[n-1];
        end
        
        // Assemble final result
        for (integer p = 0; p < NUM_STAGES; p = p + 1) begin
            result[p*STG_WIDTH +: STG_WIDTH] <= sum_pipe[p][STG_WIDTH-1:0];
        end
        result[DATA_WIDTH] <= sum_pipe[NUM_STAGES-1][STG_WIDTH];  // Final carry
        
        o_en <= en_pipe[NUM_STAGES];
    end
end

endmodule