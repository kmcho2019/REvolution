module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_stage1;  // First pipeline stage: current input latch
    reg [7:0] in_stage2;  // Second pipeline stage: previous input latch

    always @(posedge clk) begin
        in_stage1 <= in;             // Capture current input
        in_stage2 <= in_stage1;      // Capture previous input

        pedge <= (~in_stage2) & in_stage1; // Detect 0->1 transition between stages
    end

endmodule