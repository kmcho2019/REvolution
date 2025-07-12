module TopModule (
    input          clk,
    input  [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] stage1;
    reg [7:0] stage2;

    // Stage the input through two registers
    always @(posedge clk) begin
        stage1 <= in;
        stage2 <= stage1;
    end

    // Detect positive edges by comparing two delayed versions:
    // pedge bit set if the bit was 0 two cycles ago (stage2)
    // and is 1 one cycle ago (stage1). This corresponds to a rising edge one cycle ago.
    always @(posedge clk) begin
        pedge <= (~stage2) & stage1;
    end

endmodule