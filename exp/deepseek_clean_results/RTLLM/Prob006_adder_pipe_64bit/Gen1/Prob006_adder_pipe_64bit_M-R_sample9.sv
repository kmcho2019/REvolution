module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers for each 16-bit segment
reg [15:0] a1, a2, a3, a4;
reg [15:0] b1, b2, b3, b4;

// Carry registers between stages
reg carry1, carry2, carry3;

// Pipeline sum registers
reg [16:0] sum1, sum2, sum3; // 16 bits + carry

// Pipeline enable signals
reg en1, en2, en3, en4;

// Combinational additions (could be registered if needed)
wire [16:0] sum_stage1 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
wire [16:0] sum_stage2 = {1'b0, a2} + {1'b0, b2} + carry1;
wire [16:0] sum_stage3 = {1'b0, a3} + {1'b0, b3} + carry2;
wire [16:0] sum_stage4 = {1'b0, a4} + {1'b0, b4} + carry3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        {a1, a2, a3, a4} <= {4{16'b0}};
        {b1, b2, b3, b4} <= {4{16'b0}};
        {carry1, carry2, carry3} <= 3'b0;
        {sum1, sum2, sum3} <= {3{17'b0}};
        {en1, en2, en3, en4} <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Capture inputs and first sum
        a1 <= adda[15:0];
        b1 <= addb[15:0];
        sum1 <= sum_stage1;
        carry1 <= sum_stage1[16];
        en1 <= i_en;

        // Stage 2: Process next 16 bits
        a2 <= adda[31:16];
        b2 <= addb[31:16];
        sum2 <= sum_stage2;
        carry2 <= sum_stage2[16];
        en2 <= en1;

        // Stage 3: Process next 16 bits
        a3 <= adda[47:32];
        b3 <= addb[47:32];
        sum3 <= sum_stage3;
        carry3 <= sum_stage3[16];
        en3 <= en2;

        // Stage 4: Process final 16 bits
        a4 <= adda[63:48];
        b4 <= addb[63:48];
        en4 <= en3;

        // Final output assembly
        if (en4) begin
            result <= {sum_stage4[15:0], sum3[15:0], sum2[15:0], sum1[15:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule