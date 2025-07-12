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
reg [31:0] a_low, b_low, a_high, b_high;
reg [32:0] sum_low;
reg [1:0] en_pipe;

// Combinational carry signals
wire [32:0] low_sum = {1'b0, a_low} + {1'b0, b_low};
wire [32:0] high_sum = {1'b0, a_high} + {1'b0, b_high} + sum_low[32];

// Single clocked block for all sequential elements
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_low <= 32'b0;
        b_low <= 32'b0;
        a_high <= 32'b0;
        b_high <= 32'b0;
        sum_low <= 33'b0;
        en_pipe <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input registration
        if (i_en) begin
            a_low <= adda[31:0];
            b_low <= addb[31:0];
            a_high <= adda[63:32];
            b_high <= addb[63:32];
        end
        
        // Pipeline the enable signal
        en_pipe <= {en_pipe[0], i_en};
        
        // Stage 2: Lower 32-bit addition
        if (en_pipe[0]) begin
            sum_low <= low_sum;
        end
        
        // Stage 3: Final result assembly
        if (en_pipe[1]) begin
            result <= {high_sum[31:0], sum_low[31:0]};
            result[64] <= high_sum[32];
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule