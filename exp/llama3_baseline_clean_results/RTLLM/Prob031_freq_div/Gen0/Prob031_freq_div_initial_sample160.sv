module freq_div(
    input         CLK_in,    // Input clock signal
    input         RST,       // Reset signal
    output reg    CLK_50,    // Output clock signal with a frequency of CLK_in divided by 2
    output reg    CLK_10,    // Output clock signal with a frequency of CLK_in divided by 10
    output reg    CLK_1      // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0]   cnt_10;   // Counter for CLK_10
reg [5:0]   cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and outputs
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if (cnt_10 == 4) begin
            // Toggle CLK_10 and reset the counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            // Increment the counter
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1
        if (cnt_100 == 49) begin
            // Toggle CLK_1 and reset the counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            // Increment the counter
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule