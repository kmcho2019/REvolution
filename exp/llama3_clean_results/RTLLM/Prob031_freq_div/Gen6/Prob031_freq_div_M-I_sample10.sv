module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Single counter for all output clocks

always @(posedge CLK_in) begin
    if(RST) begin
        // Synchronous reset
        cnt <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Clock gating
        if(cnt == 49) begin
            // Reset counter and toggle output clocks
            cnt <= 0;
            CLK_50 <= ~CLK_50;
            if(cnt[2:0] == 4) begin
                CLK_10 <= ~CLK_10;
            end
            if(cnt == 49) begin
                CLK_1 <= ~CLK_1;
            end
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule