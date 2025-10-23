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
reg [63:0] stage_a, stage_b;
reg stage_en;

// Addition operation
wire [64:0] sum = {1'b0, stage_a} + {1'b0, stage_b};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_a <= 64'b0;
        stage_b <= 64'b0;
        stage_en <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Register inputs
        stage_a <= adda;
        stage_b <= addb;
        stage_en <= i_en;
        
        // Stage 2: Register result
        result <= sum;
        o_en <= stage_en;
    end
end

endmodule