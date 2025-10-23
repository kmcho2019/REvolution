module freq_diveven #(
    parameter NUM_DIV = 8  // division factor, must be an even number
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // active-low reset
        cnt <= 4'b0;  // reset counter to zero
        clk_div <= 1'b0;  // reset divided clock output to zero
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;  // increment counter
    end else begin
        cnt <= 4'b0;  // reset counter to zero
        clk_div <= ~clk_div;  // toggle divided clock output
    end
end

endmodule