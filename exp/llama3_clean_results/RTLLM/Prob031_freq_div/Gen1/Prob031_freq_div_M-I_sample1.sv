module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [3:0]  cnt_10;  // Counter for generating 10MHz clock
reg [6:0]  cnt_100; // Counter for generating 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_10  <= 4'b0000;
        cnt_100 <= 7'b0000000;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50  <= ~CLK_50;

        // Generate CLK_10 by counting 10 cycles of CLK_in
        if (cnt_10 == 4'b1001) begin
            // Toggle CLK_10 and reset cnt_10
            CLK_10  <= ~CLK_10;
            cnt_10  <= 4'b0000;
        end else begin
            // Increment cnt_10
            cnt_10  <= cnt_10 + 1'b1;
        end

        // Generate CLK_1 by counting 100 cycles of CLK_in
        if (cnt_100 == 7'b1100100) begin
            // Toggle CLK_1 and reset cnt_100
            CLK_1   <= ~CLK_1;
            cnt_100 <= 7'b0000000;
        end else begin
            // Increment cnt_100
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule