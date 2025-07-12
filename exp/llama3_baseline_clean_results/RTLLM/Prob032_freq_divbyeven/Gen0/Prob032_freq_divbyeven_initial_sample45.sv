module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
)(
    input  clk,           // Input clock signal
    input  rst_n,          // Active-low reset signal
    output reg clk_div     // Divided clock output signal
);

reg [3:0] cnt;            // 4-bit counter to track the number of clock cycles

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin     // Reset condition
        cnt <= 4'd0;       // Initialize counter to zero
        clk_div <= 1'b0;   // Initialize divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Counter is less than half of NUM_DIV - 1
            cnt <= cnt + 1'b1;             // Increment counter
        end else begin                     // Counter has reached the specified limit
            cnt <= 4'd0;                    // Reset counter to zero
            clk_div <= ~clk_div;           // Toggle divided clock output signal
        end
    end
end

endmodule