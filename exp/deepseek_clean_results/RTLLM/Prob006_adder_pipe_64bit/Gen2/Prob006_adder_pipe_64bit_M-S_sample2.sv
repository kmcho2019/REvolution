module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers for each 32-bit segment
reg [31:0] a1, a2;
reg [31:0] b1, b2;

// Carry register between stages
reg carry;

// Pipeline sum register
reg [32:0] sum1; // 32 bits + carry

// Pipeline enable signals
reg en1, en2;

// Combinational additions
wire [32:0] sum_stage1 = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum_stage2 = {1'b0, a2} + {1'b0, b2} + carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        a1 <= 32'b0;
        a2 <= 32'b0;
        b1 <= 32'b0;
        b2 <= 32'b0;
        carry <= 1'b0;
        sum1 <= 33'b0;
        en1 <= 1'b0;
        en2 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Capture lower 32 bits and sum
        a1 <= adda[31:0];
        b1 <= addb[31:0];
        sum1 <= sum_stage1;
        carry <= sum_stage1[32];
        en1 <= i_en;

        // Stage 2: Capture upper 32 bits
        a2 <= adda[63:32];
        b2 <= addb[63:32];
        en2 <= en1;

        // Final output assembly
        if (en2) begin
            result <= {sum_stage2[31:0], sum1[31:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule