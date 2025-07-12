module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (must be an even number)
)(
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output reg  clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output when reset signal is low
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Check if counter has reached the specified limit
        if (cnt == (NUM_DIV / 2 - 1)) begin
            // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end else if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1;
        end
    end
end

endmodule