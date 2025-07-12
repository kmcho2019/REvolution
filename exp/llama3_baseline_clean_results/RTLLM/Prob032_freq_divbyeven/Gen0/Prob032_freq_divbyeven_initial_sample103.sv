module freq_diveven #(
    parameter NUM_DIV = 4  // division factor, must be an even number
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // initialize counter and divided clock signal to zero when reset is low
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // increment counter without changing divided clock output
            cnt <= cnt + 1;
        end else begin
            // reset counter to zero and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule