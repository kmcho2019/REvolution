module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: set counter and clk_div to 0
        cnt <= 0;
        clk_div <= 0;
    end else begin
        // Check if the counter has reached the halfway point of NUM_DIV - 1
        if (cnt == (NUM_DIV / 2 - 1)) begin
            // Reset counter and toggle clk_div
            cnt <= 0;
            clk_div <= ~clk_div;
        end else begin
            // Increment counter
            cnt <= cnt + 1;
        end
    end
end

endmodule