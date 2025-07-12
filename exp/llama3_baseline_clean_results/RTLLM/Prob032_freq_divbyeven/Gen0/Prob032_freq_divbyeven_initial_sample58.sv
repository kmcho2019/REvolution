module freq_diveven #(
    parameter NUM_DIV = 10  // Example even division factor
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset
        cnt  <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;  // Toggle clk_div
        end
    end
end

endmodule