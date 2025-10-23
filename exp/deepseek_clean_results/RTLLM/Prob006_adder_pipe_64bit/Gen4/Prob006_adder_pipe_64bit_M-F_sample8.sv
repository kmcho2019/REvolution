module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 4;

// Pipeline registers
reg [DATA_WIDTH-1:0] adda_pipe [0:STG_WIDTH-1];
reg [DATA_WIDTH-1:0] addb_pipe [0:STG_WIDTH-1];
reg [STG_WIDTH-1:0] en_pipe;

// Internal signals
wire [64:0] sum [0:STG_WIDTH-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STG_WIDTH; i = i + 1) begin : PIPE_STAGES
        if (i == 0) begin
            // First stage - simple addition
            assign sum[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]};
        end else begin
            // Subsequent stages - add with carry from previous stage
            assign sum[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + sum[i-1][64];
        end
    end
endgenerate

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        for (integer j = 0; j < STG_WIDTH; j = j + 1) begin
            adda_pipe[j] <= {DATA_WIDTH{1'b0}};
            addb_pipe[j] <= {DATA_WIDTH{1'b0}};
        end
        en_pipe <= {STG_WIDTH{1'b0}};
        result <= {65{1'b0}};
        o_en <= 1'b0;
    end else begin
        // Input stage
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        en_pipe[0] <= i_en;
        
        // Pipeline propagation
        for (integer j = 1; j < STG_WIDTH; j = j + 1) begin
            adda_pipe[j] <= adda_pipe[j-1];
            addb_pipe[j] <= addb_pipe[j-1];
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Output stage
        if (en_pipe[STG_WIDTH-1]) begin
            result <= sum[STG_WIDTH-1];
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule