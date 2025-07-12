module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number

reg [3:0] cnt;  // Fixed 4-bit counter (supports up to divide by 32)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            clk_div <= ~clk_div;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule