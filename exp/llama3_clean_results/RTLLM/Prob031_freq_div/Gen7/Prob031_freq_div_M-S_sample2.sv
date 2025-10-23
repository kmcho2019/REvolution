module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_50;  // Counter for 50MHz clock
reg [3:0] cnt_10;  // Counter for 10MHz clock
reg [6:0] cnt_100;  // Counter for 1MHz clock

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
        // Generate 50MHz clock
        if(cnt_50 == 1) begin
            cnt_50 <= 0;
            CLK_50 <= ~CLK_50;
        end else begin
            cnt_50 <= cnt_50 + 1;
        end

        // Generate 10MHz clock
        if(cnt_10 == 9) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate 1MHz clock
        if(cnt_100 == 99) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule