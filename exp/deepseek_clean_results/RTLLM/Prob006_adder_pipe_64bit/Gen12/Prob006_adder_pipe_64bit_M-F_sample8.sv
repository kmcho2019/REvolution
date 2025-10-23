module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline parameters
localparam PIPELINE_DEPTH = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [63:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [PIPELINE_DEPTH-1:0] en_pipe;
reg [64:0] partial_sum [0:PIPELINE_DEPTH-1];

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
            partial_sum[i] <= 65'b0;
        end
        en_pipe <= {PIPELINE_DEPTH{1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        partial_sum[0] <= {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
        en_pipe[0] <= i_en;

        // Stage 1: Add next 16 bits with carry from stage 0
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        partial_sum[1] <= {1'b0, a_pipe[0][31:16]} + {1'b0, b_pipe[0][31:16]} + partial_sum[0][16];
        en_pipe[1] <= en_pipe[0];

        // Stage 2: Add next 16 bits with carry from stage 1
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        partial_sum[2] <= {1'b0, a_pipe[1][47:32]} + {1'b0, b_pipe[1][47:32]} + partial_sum[1][16];
        en_pipe[2] <= en_pipe[1];

        // Stage 3: Add final 16 bits with carry from stage 2
        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        partial_sum[3] <= {1'b0, a_pipe[2][63:48]} + {1'b0, b_pipe[2][63:48]} + partial_sum[2][16];
        en_pipe[3] <= en_pipe[2];

        // Final output assembly
        if (en_pipe[3]) begin
            result <= {partial_sum[3][16], 
                      partial_sum[3][15:0], 
                      partial_sum[2][15:0], 
                      partial_sum[1][15:0], 
                      partial_sum[0][15:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule