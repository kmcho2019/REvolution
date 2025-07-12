module freq_div (
    input          CLK_in,  // Input clock signal
    input          RST,     // Reset signal
    output         CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output         CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output         CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg     CLK_50_reg;
reg     CLK_10_reg;
reg     CLK_1_reg;
reg [6:0]  cnt; // 7-bit counter

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Synchronous reset: Reset all the counters and output clocks on the positive edge of CLK_in or RST
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        CLK_1_reg <= 1'b0;
        cnt <= 7'd0;
    end else begin
        // Increment the counter on every positive edge of CLK_in
        cnt <= cnt + 1'b1;
        
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50_reg <= ~CLK_50_reg;
        
        // Toggle CLK_10 when cnt reaches 9 (for 100MHz / 10 = 10MHz)
        if (cnt == 7'd9) begin
            CLK_10_reg <= ~CLK_10_reg;
        end
        
        // Toggle CLK_1 when cnt reaches 99 (for 100MHz / 100 = 1MHz)
        if (cnt == 7'd99) begin
            CLK_1_reg <= ~CLK_1_reg;
        end
        
        // Reset the counter when it reaches 100
        if (cnt == 7'd100) begin
            cnt <= 7'd0;
        end
    end
end

endmodule