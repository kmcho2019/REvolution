module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_50;  // Counter for CLK_50
reg [3:0] cnt_10;  // Counter for CLK_10
reg [6:0] cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and output clocks
        cnt_50 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment counters
        cnt_50 <= cnt_50 + 1;
        cnt_10 <= cnt_10 + 1;
        cnt_100 <= cnt_100 + 1;

        // Toggle output clocks based on counter values
        if(cnt_50 == 1) begin
            CLK_50 <= ~CLK_50;
            cnt_50 <= 0;
        end

        if(cnt_10 == 9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end

        if(cnt_100 == 99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule