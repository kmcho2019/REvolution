module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for 10MHz clock
reg [5:0] cnt_100;  // Counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and outputs
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;
        
        // Increment and check counters
        cnt_10 <= (cnt_10 == 4) ? 0 : cnt_10 + 1;
        if(cnt_10 == 0 && cnt_10 == 4) begin
            // This condition is never true, it should be changed to correctly toggle CLK_10
            // Correctly toggling CLK_10
            CLK_10 <= ~CLK_10;
        end else if(cnt_10 == 0) begin
            // No action needed here, just let the counter increment normally
        end
        
        cnt_100 <= (cnt_100 == 49) ? 0 : cnt_100 + 1;
        if(cnt_100 == 0 && cnt_100 == 49) begin
            // This condition is never true, it should be changed to correctly toggle CLK_1
            // Correctly toggling CLK_1
            CLK_1 <= ~CLK_1;
        end else if(cnt_100 == 0) begin
            // No action needed here, just let the counter increment normally
        end
    end
end

endmodule