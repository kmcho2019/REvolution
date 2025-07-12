module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Shared counter for 10MHz and 1MHz clocks

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and output clocks
        cnt <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 by inverting its current value
        CLK_50 <= ~CLK_50;
        
        // Update shared counter for 10MHz and 1MHz clocks
        cnt <= cnt + 1;
        
        // Toggle CLK_10 by inverting its current value every 10 clock cycles
        if(cnt == 9) begin
            CLK_10 <= ~CLK_10;
            cnt <= 0;
        end
        
        // Toggle CLK_1 by inverting its current value every 100 clock cycles
        if(cnt == 99) begin
            CLK_1 <= ~CLK_1;
            cnt <= 0;
        end
    end
end

endmodule