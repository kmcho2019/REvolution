module freq_div (
    input  CLK_in, // Input clock signal
    input  RST,     // Reset signal
    output reg CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1  // Output clock signal with a frequency of CLK_in divided by 100
);

reg [3:0] cnt_10; // Counter for CLK_10
reg [6:0] cnt_100; // Counter for CLK_1

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all clocks and counters when RST is active
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
        cnt_10 <= 4'd0;
        cnt_100 <= 7'd0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4'd9) begin
            // Toggle CLK_10 when cnt_10 reaches 9
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end

        // Generate CLK_1
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 7'd99) begin
            // Toggle CLK_1 when cnt_100 reaches 99
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'd0;
        end
    end
end

endmodule