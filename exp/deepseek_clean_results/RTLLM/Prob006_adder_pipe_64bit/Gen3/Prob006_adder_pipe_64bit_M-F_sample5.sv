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
reg [63:0] stage1_a, stage1_b;
reg en1;

// Carry signals
reg [63:0] sum;
reg carry_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en1 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline Stage 1: Register inputs
        stage1_a <= adda;
        stage1_b <= addb;
        en1 <= i_en;
        
        // Pipeline Stage 2: Perform addition
        o_en <= en1;
        
        if (en1) begin
            // Ripple carry addition
            {carry_out, sum[0]} = stage1_a[0] + stage1_b[0];
            for (integer i = 1; i < 64; i = i + 1) begin
                {carry_out, sum[i]} = stage1_a[i] + stage1_b[i] + carry_out;
            end
            
            // Final result with carry out
            result <= {carry_out, sum};
        end else begin
            result <= 65'b0;
        end
    end
end

endmodule