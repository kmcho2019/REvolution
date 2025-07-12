module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers - 3 stages
reg [63:0] a_pipe [0:2];
reg [63:0] b_pipe [0:2];
reg [64:0] sum_pipe [0:2];

// Enable pipeline - matches data pipeline depth
reg [2:0] en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_pipe[0] <= 64'b0;
        a_pipe[1] <= 64'b0;
        a_pipe[2] <= 64'b0;
        b_pipe[0] <= 64'b0;
        b_pipe[1] <= 64'b0;
        b_pipe[2] <= 64'b0;
        sum_pipe[0] <= 65'b0;
        sum_pipe[1] <= 65'b0;
        sum_pipe[2] <= 65'b0;
        en_pipe <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input sampling
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        sum_pipe[0] <= {1'b0, adda} + {1'b0, addb};
        
        // Stage 2: First pipeline register
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        sum_pipe[1] <= sum_pipe[0];
        
        // Stage 3: Second pipeline register
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        sum_pipe[2] <= sum_pipe[1];
        
        // Final output
        result <= sum_pipe[2];
        
        // Enable signal pipeline
        en_pipe <= {en_pipe[1:0], i_en};
        o_en <= en_pipe[2];
    end
end

endmodule