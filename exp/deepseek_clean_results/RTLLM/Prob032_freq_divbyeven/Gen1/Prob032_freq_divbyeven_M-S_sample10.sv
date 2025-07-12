module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    reg [3:0] cnt;  // 4-bit counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) {cnt, clk_div} <= 5'b0;
        else begin
            cnt <= (cnt == 4'd1) ? 4'b0 : cnt + 1;  // Divide by 4 (2^2)
            clk_div <= (cnt == 4'd1) ? ~clk_div : clk_div;
        end
    end

endmodule