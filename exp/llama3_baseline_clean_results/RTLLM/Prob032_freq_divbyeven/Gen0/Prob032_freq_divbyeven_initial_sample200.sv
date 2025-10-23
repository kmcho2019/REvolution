module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input   clk,           // Input clock signal
    input   rst_n,         // Active-low reset signal
    output  clk_div        // Divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter
reg       clk_div_r;      // Internal divided clock signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt     <= 4'd0;
        clk_div_r <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'd0;
            clk_div_r <= ~clk_div_r;
        end
    end
end

assign clk_div = clk_div_r;

endmodule