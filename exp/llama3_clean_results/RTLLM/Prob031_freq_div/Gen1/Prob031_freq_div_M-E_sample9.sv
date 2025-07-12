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
reg [6:0]  cnt;  // 7-bit counter

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset the counter and output clocks
        cnt <= 7'd0;
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        CLK_1_reg <= 1'b0;
    end else begin
        // Increment the counter
        if (cnt == 7'd99) begin
            cnt <= 7'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Toggle CLK_50
        if (cnt[0] == 1'b0) begin
            CLK_50_reg <= ~CLK_50_reg;
        end
        
        // Toggle CLK_10
        if (cnt == 7'd9) begin
            CLK_10_reg <= ~CLK_10_reg;
        end
        
        // Toggle CLK_1
        if (cnt == 7'd99) begin
            CLK_1_reg <= ~CLK_1_reg;
        end
    end
end

endmodule