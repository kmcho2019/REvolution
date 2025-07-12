module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0]  cnt_2;  // Counter for generating CLK_50
reg [2:0]  cnt_10; // Counter for generating CLK_10
reg [5:0]  cnt_100; // Counter for generating CLK_1

always @(posedge CLK_in) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_2   <= 2'b00;
        cnt_10  <= 3'b000;
        cnt_100 <= 6'b000000;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50  <= ~CLK_50;
        cnt_2   <= cnt_2 + 1'b1;

        // Generate CLK_10 by counting 10 cycles of CLK_in (5 cycles of CLK_50)
        cnt_10  <= cnt_10 + 1'b1;
        if (cnt_10 == 3'd4) begin
            // Toggle CLK_10 and reset cnt_10
            CLK_10  <= ~CLK_10;
            cnt_10  <= 3'b000;
        end

        // Generate CLK_1 by counting 100 cycles of CLK_in (50 cycles of CLK_50)
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 6'd49) begin
            // Toggle CLK_1 and reset cnt_100
            CLK_1   <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end
    end
end

endmodule