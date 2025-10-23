module freq_diveven(
    input clk, 
    input rst_n, 
    output reg clk_div
);

parameter NUM_DIV = 4;  // Division factor, must be an even number

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock output when reset signal is low
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt < (NUM_DIV / 2) - 1) begin
        // Increment the counter without changing the divided clock output
        cnt <= cnt + 1;
    end else begin
        // Reset the counter and toggle the divided clock output
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end
end

endmodule