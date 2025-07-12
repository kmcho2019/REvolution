module freq_div (
    input  CLK_in,  // Input clock signal
    input  RST,     // Reset signal
    output reg  CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg  CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg  CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for CLK_50 (not needed, since we can simply toggle the signal)
reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks on reset
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
        cnt_10 <= 3'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Update CLK_10 and cnt_10
        if (cnt_10 == 4'd9) begin
            // Toggle CLK_10 and reset cnt_10
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            // Increment cnt_10
            cnt_10 <= cnt_10 + 1;
        end
        
        // Update CLK_1 and cnt_100
        if (cnt_100 == 6'd99) begin
            // Toggle CLK_1 and reset cnt_100
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            // Increment cnt_100
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule