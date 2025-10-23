module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] stage [7:0];  // 8 stages of 8-bit registers

    always @(posedge clk) begin
        if (reset) begin
            for (integer i = 0; i < 8; i = i + 1) begin
                stage[i] <= 8'b0;  // Reset all stages
            end
        end
        else begin
            stage[0] <= d;  // First stage gets external input
            for (integer i = 1; i < 8; i = i + 1) begin
                stage[i] <= stage[i-1];  // Subsequent stages get previous stage
            end
        end
    end

    assign q = stage[7];  // Output comes from last stage

endmodule