module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  clk,         // Input clock signal
    input  rst_n,       // Active-low reset signal
    output clk_div      // Divided clock output signal
);

reg [3:0] cnt;          // 4-bit counter to track clock cycles
reg       clk_div;      // Divided clock output signal

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock signal when reset is low
        cnt   <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            // Increment counter without changing divided clock output
            cnt   <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt   <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule