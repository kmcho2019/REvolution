module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0]  cnt;  // Counter for generating clocks

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt     <= 7'b0000000;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50  <= ~CLK_50;

        // Increment the counter
        cnt <= cnt + 1'b1;

        // Generate CLK_10 by counting 10 cycles of CLK_in (since CLK_50 is half of CLK_in, we count 5 cycles of CLK_50 or 10 cycles of CLK_in)
        if (cnt == 7'd9) begin
            // Toggle CLK_10 and reset cnt
            CLK_10  <= ~CLK_10;
            cnt     <= 7'b0000000;
        end

        // Generate CLK_1 by counting 100 cycles of CLK_in (since CLK_50 is half of CLK_in, we count 50 cycles of CLK_50 or 100 cycles of CLK_in)
        if (cnt == 7'd99) begin
            // Toggle CLK_1
            CLK_1   <= ~CLK_1;
        end
    end
end

endmodule