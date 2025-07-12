module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Single counter for all output clocks

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
        if(cnt == 7'd99) begin
            CLK_1 <= ~CLK_1;
            cnt <= 0;
        end else if(cnt == 7'd49) begin
            CLK_1 <= ~CLK_1;
        end
        
        if(cnt == 7'd9) begin
            CLK_10 <= ~CLK_10;
            cnt <= 0;
        end else if(cnt == 7'd4) begin
            CLK_10 <= ~CLK_10;
        end
        
        if(cnt == 7'd1) begin
            CLK_50 <= ~CLK_50;
            cnt <= 0;
        end else if(cnt == 7'd0) begin
            CLK_50 <= ~CLK_50;
        end
    end
end

endmodule