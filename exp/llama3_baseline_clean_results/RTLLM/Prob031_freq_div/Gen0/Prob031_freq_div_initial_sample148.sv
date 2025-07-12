module freq_div(
    input  wire        CLK_in,  // Input clock signal
    input  wire        RST,     // Reset signal
    output reg          CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg          CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg          CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg [3:0] cnt_10;  // Counter to divide the frequency by 10
reg [6:0] cnt_100; // Counter to divide the frequency by 100

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clock signals
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;

        // Count up to 9 and toggle CLK_10
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Count up to 99 and toggle CLK_1
        if (cnt_100 == 7'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule