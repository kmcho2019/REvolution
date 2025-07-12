module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 10; // Even number division factor

reg [3:0] cnt; // 4-bit counter register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule