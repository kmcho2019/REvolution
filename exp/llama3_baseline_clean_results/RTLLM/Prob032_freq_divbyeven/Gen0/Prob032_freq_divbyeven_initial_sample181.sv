module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Even number division factor, change as needed

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'd0; // Reset counter to 0
        clk_div <= 1'b0; // Reset divided clock output to 0
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // Increment counter until it reaches half of NUM_DIV - 1
            cnt <= cnt + 1;
        end else begin // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule