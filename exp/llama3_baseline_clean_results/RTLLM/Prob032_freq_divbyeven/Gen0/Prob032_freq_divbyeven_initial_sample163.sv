module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Division factor (even number)

reg [3:0] cnt; // Counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000; // Reset counter to zero
        clk_div <= 1'b0; // Reset divided clock to zero
    end else if (cnt < (NUM_DIV / 2) - 1) begin
        cnt <= cnt + 1'b1; // Increment counter
    end else begin
        cnt <= 4'b0000; // Reset counter to zero
        clk_div <= ~clk_div; // Toggle divided clock
    end
end

endmodule