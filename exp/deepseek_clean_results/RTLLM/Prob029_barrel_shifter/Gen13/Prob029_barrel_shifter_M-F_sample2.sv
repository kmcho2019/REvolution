module barrel_shifter(
    input [7:0] in,        // 8-bit input to be rotated right
    input [2:0] ctrl,      // Control bits: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output reg [7:0] out   // Rotated output (right rotation)
);

    // Internal signals for intermediate rotation results
    wire [7:0] stage4, stage2;

    // Stage 1: 4-bit right rotation when ctrl[2] is high
    // Example: in=8'bABCDEFGH becomes EFGHABCD when ctrl[2]=1
    assign stage4 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: 2-bit right rotation when ctrl[1] is high
    // Applied to result of previous stage (either original or 4-bit rotated)
    // Example: stage4=8'bABCDEFGH becomes GHABCDEF when ctrl[1]=1
    assign stage2 = ctrl[1] ? {stage4[1:0], stage4[7:2]} : stage4;

    // Stage 3: 1-bit right rotation when ctrl[0] is high
    // Applied to result of previous stage
    // Example: stage2=8'bABCDEFGH becomes HABCDEFG when ctrl[0]=1
    // Note: Combined shifts work correctly (e.g., ctrl=3'b111 -> 7-bit rotation)
    always @(*) begin
        out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;
    end

    // Special cases:
    // ctrl=3'b000: out = in (no rotation)
    // ctrl=3'b111: full 7-bit rotation (equivalent to 1-bit left rotation)
endmodule