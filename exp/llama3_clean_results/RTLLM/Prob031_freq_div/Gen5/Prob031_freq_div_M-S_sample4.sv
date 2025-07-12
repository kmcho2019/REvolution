module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [3:0]  cnt_10;  // Counter for generating CLK_10
reg [6:0]  cnt_100; // Counter for generating CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_10  <= 4'b0000;
        cnt_100 <= 7'b0000000;
    end else begin
        // Toggle CLK_50 by inverting its current value
        CLK_50  <= ~CLK_50;

        // Generate CLK_10 by toggling every 10 counts
        cnt_10  <= (cnt_10 == 4'd9) ? 4'b0000 : cnt_10 + 1'b1;
        CLK_10  <= (cnt_10 == 4'd9) ? ~CLK_10 : CLK_10;

        // Generate CLK_1 by toggling every 100 counts
        cnt_100 <= (cnt_100 == 7'd99) ? 7'b0000000 : cnt_100 + 1'b1;
        CLK_1   <= (cnt_100 == 7'd99) ? ~CLK_1 : CLK_1;
    end
end

endmodule