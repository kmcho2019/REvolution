module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0]  cnt;  // Shared counter for generating all output clocks

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt     <= 7'b0000000;
    end else begin
        // Increment shared counter
        cnt     <= cnt + 1'b1;

        // Generate CLK_50 by toggling on every other count
        if (cnt[0] == 1'b1) begin
            CLK_50  <= ~CLK_50;
        end

        // Generate CLK_10 by toggling every 10 counts
        if (cnt[3:0] == 4'b1001) begin
            // Toggle CLK_10 and reset lower 4 bits of cnt
            CLK_10  <= ~CLK_10;
            cnt[3:0] <= 4'b0000;
        end

        // Generate CLK_1 by toggling every 100 counts
        if (cnt == 7'b1100100) begin
            // Toggle CLK_1 and reset cnt
            CLK_1   <= ~CLK_1;
            cnt     <= 7'b0000000;
        end
    end
end

endmodule