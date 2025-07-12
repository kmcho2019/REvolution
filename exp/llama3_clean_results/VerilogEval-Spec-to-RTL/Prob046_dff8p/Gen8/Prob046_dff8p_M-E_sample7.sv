module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VALUE = 8'h34,
    parameter PIPELINE_DEPTH = 2
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] stage1 [PIPELINE_DEPTH-1:0];
reg [WIDTH-1:0] stage2 [PIPELINE_DEPTH-1:0];

integer i;

always @(negedge clk) begin
    if (reset) begin
        for (i = 0; i < PIPELINE_DEPTH; i++) begin
            stage1[i] <= RESET_VALUE;
            stage2[i] <= RESET_VALUE;
        end
    end else begin
        stage1[0] <= d;
        for (i = 1; i < PIPELINE_DEPTH; i++) begin
            stage1[i] <= stage1[i-1];
        end
        stage2[0] <= stage1[PIPELINE_DEPTH-1];
        for (i = 1; i < PIPELINE_DEPTH; i++) begin
            stage2[i] <= stage2[i-1];
        end
    end
end

assign q = stage2[PIPELINE_DEPTH-1];

endmodule