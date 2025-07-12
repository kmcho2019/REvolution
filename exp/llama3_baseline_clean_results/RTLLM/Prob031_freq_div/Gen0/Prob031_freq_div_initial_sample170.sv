module freq_div(
    input  CLK_in, // Input clock signal
    input  RST,    // Reset signal
    output reg     CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg     CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg     CLK_1  // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for dividing by 2
reg [2:0] cnt_10; // Counter for dividing by 10
reg [5:0] cnt_100; // Counter for dividing by 100

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clock signals
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Increment counter for CLK_10 and toggle CLK_10 when counter reaches 4
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Increment counter for CLK_1 and toggle CLK_1 when counter reaches 49
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule