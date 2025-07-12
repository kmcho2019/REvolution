module barrel_shifter(
    input [7:0] in,        // 8-bit input to be rotated
    input [2:0] ctrl,      // Control bits: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output reg [7:0] out   // Rotated output
);

    // Internal signals for intermediate rotation results
    wire [7:0] stage4, stage2;

    // Stage 1: 4-bit right rotation when ctrl[2] is high
    // Moves lower 4 bits to upper positions
    assign stage4 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: 2-bit right rotation when ctrl[1] is high
    // Applied to result of previous stage
    // Moves lower 2 bits to upper positions
    assign stage2 = ctrl[1] ? {stage4[1:0], stage4[7:2]} : stage4;

    // Stage 3: 1-bit right rotation when ctrl[0] is high
    // Applied to result of previous stage
    // Moves LSB to MSB position
    always @(*) begin
        out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;
    end

endmodule