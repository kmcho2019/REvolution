module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_stage1, b_stage1;
reg [63:0] a_stage2, b_stage2;
reg [32:0] sum_low;    // Lower 32 bits + carry
reg [32:0] sum_high;   // Upper 32 bits + carry
reg [1:0] en_pipe;

// Combinational sums
wire [32:0] sum0 = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum1 = {1'b0, a_stage1[63:32]} + {1'b0, b_stage1[63:32]} + sum_low[32];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers
        a_stage1 <= 64'b0;
        b_stage1 <= 64'b0;
        a_stage2 <= 64'b0;
        b_stage2 <= 64'b0;
        sum_low <= 33'b0;
        sum_high <= 33'b0;
        en_pipe <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline enable signal
        en_pipe <= {en_pipe[0], i_en};
        
        // Stage 1: Process lower 32 bits
        a_stage1 <= adda;
        b_stage1 <= addb;
        sum_low <= sum0;
        
        // Stage 2: Process upper 32 bits with carry
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        sum_high <= sum1;
        
        // Output result when valid
        if (en_pipe[1]) begin
            result <= {sum_high[32], sum_high[31:0], sum_low[31:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule