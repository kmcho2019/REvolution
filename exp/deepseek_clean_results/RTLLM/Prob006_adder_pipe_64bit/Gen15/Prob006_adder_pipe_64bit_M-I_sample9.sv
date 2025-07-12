module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output wire [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH/STG_WIDTH;
localparam STAGES = (DATA_WIDTH % STG_WIDTH) ? NUM_STAGES + 1 : NUM_STAGES;

// Pipeline registers
reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
reg [0:STAGES-1] carry_pipe;
reg [0:STAGES] en_pipe;

// Partial sums
wire [STG_WIDTH:0] partial_sum [0:STAGES-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : pipeline
        if (i == 0) begin
            // First stage
            assign partial_sum[i] = {1'b0, adda[STG_WIDTH-1:0]} + 
                                  {1'b0, addb[STG_WIDTH-1:0]};
        end else begin
            // Subsequent stages
            assign partial_sum[i] = {1'b0, adda_pipe[i][STG_WIDTH-1:0]} + 
                                  {1'b0, addb_pipe[i][STG_WIDTH-1:0]} + 
                                  carry_pipe[i-1];
        end
    end
endgenerate

// Result construction
wire [DATA_WIDTH:0] full_result;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : result_construction
        assign full_result[(i+1)*STG_WIDTH-1:i*STG_WIDTH] = partial_sum[i][STG_WIDTH-1:0];
    end
endgenerate
assign full_result[DATA_WIDTH] = carry_pipe[STAGES-1];
assign result = full_result;

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer j = 0; j < STAGES; j = j + 1) begin
            adda_pipe[j] <= '0;
            addb_pipe[j] <= '0;
            carry_pipe[j] <= '0;
        end
        en_pipe <= '0;
        o_en <= 0;
    end else begin
        // First stage inputs
        adda_pipe[0] <= adda[STG_WIDTH-1:0];
        addb_pipe[0] <= addb[STG_WIDTH-1:0];
        carry_pipe[0] <= partial_sum[0][STG_WIDTH];
        
        // Pipeline propagation
        for (integer j = 1; j < STAGES; j = j + 1) begin
            adda_pipe[j] <= adda[(j+1)*STG_WIDTH-1:j*STG_WIDTH];
            addb_pipe[j] <= addb[(j+1)*STG_WIDTH-1:j*STG_WIDTH];
            carry_pipe[j] <= partial_sum[j][STG_WIDTH];
        end
        
        // Enable signal pipeline
        en_pipe[0] <= i_en;
        for (integer j = 1; j <= STAGES; j = j + 1) begin
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Output enable
        o_en <= en_pipe[STAGES];
    end
end

endmodule