module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] stage1;
    reg [7:0] stage2;

    always @(posedge clk) begin
        stage1 <= in;          // Capture input at first pipeline stage
        stage2 <= stage1;      // Capture input at second pipeline stage

        // Positive edge occurs if stage2 was 0 and stage1 is 1 (from two cycles ago to previous cycle)
        // Output pedge is assigned in current cycle, i.e., one cycle after the edge.
        pedge <= (~stage2) & stage1;
    end

endmodule