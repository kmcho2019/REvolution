module freq_diveven #(
    parameter NUM_DIV = 8 // Division factor, must be an even number
)(
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output reg         clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter to track clock cycles

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        cnt <= 4'd0; // Reset counter to 0
        clk_div <= 1'b0; // Reset divided clock to 0
    end else if (cnt < (NUM_DIV / 2 - 1)) begin // Increment counter if it hasn't reached the limit
        cnt <= cnt + 1; // Increment counter
        clk_div <= clk_div; // Keep divided clock the same
    end else begin // Counter has reached the limit, reset it and toggle divided clock
        cnt <= 4'd0; // Reset counter to 0
        clk_div <= ~clk_div; // Toggle divided clock
    end
end

endmodule