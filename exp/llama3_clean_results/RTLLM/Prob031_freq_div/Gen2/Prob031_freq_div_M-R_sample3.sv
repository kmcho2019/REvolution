module freq_div (
    input          CLK_in,  // Input clock signal
    input          RST,     // Reset signal
    output         CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output         CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output         CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Single counter to generate all frequencies

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Synchronous reset: Reset the counter on the positive edge of CLK_in or RST
        cnt <= 7'd0;
    end else begin
        // Increment the counter on every positive edge of CLK_in
        cnt <= cnt + 1'b1;
    end
end

// Derive output frequencies from the single counter
assign CLK_50 = cnt[0];  // Toggle every clock cycle
assign CLK_10 = cnt[3];  // Toggle every 8 clock cycles
assign CLK_1 = cnt[6];   // Toggle every 64 clock cycles

endmodule