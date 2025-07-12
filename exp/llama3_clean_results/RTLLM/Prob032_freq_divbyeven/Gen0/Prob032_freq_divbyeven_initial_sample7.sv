module freq_diveven #(
    parameter NUM_DIV = 4 // Division factor (even number)
) (
    input  clk,        // Input clock signal
    input  rst_n,       // Active-low reset signal
    output clk_div      // Divided clock output signal
);

reg [3:0] cnt;          // 4-bit counter
reg       clk_div_r;   // Registered divided clock output signal

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter and divided clock output
        cnt         <= 4'd0;
        clk_div_r   <= 1'b0;
    end else if (cnt < (NUM_DIV / 2) - 1) begin
        // Increment counter
        cnt         <= cnt + 1'b1;
    end else begin
        // Reset counter and toggle divided clock output
        cnt         <= 4'd0;
        clk_div_r   <= ~clk_div_r;
    end
end

// Continuous assignment for output signal
assign clk_div = clk_div_r;

endmodule