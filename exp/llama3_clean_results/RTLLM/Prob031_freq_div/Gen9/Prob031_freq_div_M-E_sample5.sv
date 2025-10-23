module freq_div #(
    parameter CLK_50_TOGGLE = 1,
    parameter CLK_10_TOGGLE = 4,
    parameter CLK_1_TOGGLE = 49
)(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [5:0] cnt;  // Single counter for all output clocks

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counter and output clocks
        cnt <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment counter
        cnt <= cnt + 1;
        
        // Toggle output clocks based on counter value
        if(cnt == CLK_50_TOGGLE) begin
            CLK_50 <= ~CLK_50;
        end
        
        if(cnt == CLK_10_TOGGLE) begin
            CLK_10 <= ~CLK_10;
        end
        
        if(cnt == CLK_1_TOGGLE) begin
            CLK_1 <= ~CLK_1;
        end
        
        // Reset counter when it reaches the maximum toggle value
        if(cnt == CLK_1_TOGGLE) begin
            cnt <= 0;
        end
    end
end

endmodule