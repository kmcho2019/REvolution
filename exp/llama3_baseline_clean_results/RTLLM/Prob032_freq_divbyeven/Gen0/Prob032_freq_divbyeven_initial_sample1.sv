module freq_diveven #(
    parameter NUM_DIV = 10 // Default division factor, must be an even number
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt; // 4-bit counter to track the number of clock cycles

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active-low reset
        cnt <= 4'd0; // Reset counter
        clk_div <= 1'b0; // Initialize divided clock signal
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // Counter increments until it reaches half of NUM_DIV - 1
            cnt <= cnt + 1;
        end else begin // Reset counter and toggle divided clock signal
            cnt <= 4'd0;
            clk_div <= ~clk_div; // Toggle divided clock signal
        end
    end
end

endmodule