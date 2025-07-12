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

// Calculate pipeline depth based on parameters
localparam PIPELINE_DEPTH = DATA_WIDTH / STG_WIDTH;

// Pipeline registers
reg [DATA_WIDTH-1:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [DATA_WIDTH-1:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [PIPELINE_DEPTH-1:0] en_pipe;
reg [STG_WIDTH:0] partial_sum [0:PIPELINE_DEPTH-1];

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= {DATA_WIDTH{1'b0}};
            b_pipe[i] <= {DATA_WIDTH{1'b0}};
            partial_sum[i] <= {(STG_WIDTH+1){1'b0}};
        end
        en_pipe <= {PIPELINE_DEPTH{1'b0}};
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        partial_sum[0] <= {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};
        en_pipe[0] <= i_en;

        // Subsequent stages
        for (integer i = 1; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= a_pipe[i-1];
            b_pipe[i] <= b_pipe[i-1];
            partial_sum[i] <= {1'b0, a_pipe[i-1][(i+1)*STG_WIDTH-1:i*STG_WIDTH]} + 
                              {1'b0, b_pipe[i-1][(i+1)*STG_WIDTH-1:i*STG_WIDTH]} + 
                              partial_sum[i-1][STG_WIDTH];
            en_pipe[i] <= en_pipe[i-1];
        end

        // Final output assembly
        if (en_pipe[PIPELINE_DEPTH-1]) begin
            result[DATA_WIDTH] <= partial_sum[PIPELINE_DEPTH-1][STG_WIDTH];
            for (integer i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
                result[i*STG_WIDTH +: STG_WIDTH] <= partial_sum[i][STG_WIDTH-1:0];
            end
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule