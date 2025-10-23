module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1

always @(posedge RST) begin
    // Reset counters and output clocks on reset
    cnt_10 <= 0;
    cnt_100 <= 0;
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
end

always @(posedge CLK_in) begin
    // Toggle CLK_50 on every positive edge of CLK_in
    CLK_50 <= ~CLK_50;
    
    // Increment counters
    if (~RST) begin
        if(cnt_10 == 4) begin
            // Toggle CLK_10 and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            // Increment counter
            cnt_10 <= cnt_10 + 1;
        end
        
        if(cnt_100 == 49) begin
            // Toggle CLK_1 and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            // Increment counter
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule