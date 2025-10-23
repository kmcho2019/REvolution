module TopModule(
    input [99:0] in,
    output reg [99:0] out
);

reg [99:0] stage1 [0:9];
reg [99:0] stage2 [0:4];
reg [99:0] stage3 [0:1];

integer i, j;

always @(*) begin
    // Stage 1: Shift and multiplex 10 bits at a time
    for (i = 0; i < 10; i++) begin
        for (j = 0; j < 10; j++) begin
            stage1[i][9 - j] = in[i * 10 + j];
        end
    end

    // Stage 2: Shift and multiplex 20 bits at a time
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 20; j++) begin
            stage2[i][19 - j] = stage1[i * 2 + (j < 10)][j % 10];
        end
    end

    // Stage 3: Shift and multiplex 40 bits at a time
    for (i = 0; i < 2; i++) begin
        for (j = 0; j < 40; j++) begin
            stage3[i][39 - j] = stage2[i * 2 + (j < 20)][j % 20];
        end
    end

    // Stage 4: Final output
    for (i = 0; i < 100; i++) begin
        out[i] = stage3[(i < 40) ? 0 : 1][i % 40];
    end
end

endmodule