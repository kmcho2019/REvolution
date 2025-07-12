module freq_div (
    input          CLK_in,  // Input clock signal
    input          RST,     // Reset signal
    output         CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output         CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output         CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg             CLK_50;  // Output clock signal for 50MHz
reg             CLK_10;  // Output clock signal for 10MHz
reg             CLK_1;   // Output clock signal for 1MHz
reg [1:0]       cnt_2;    // Counter for 50MHz clock
reg [3:0]       cnt_10;   // Counter for 10MHz clock
reg [5:0]       cnt_100;  // Counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Synchronous reset: Reset all counters and output clocks
        CLK_50 <= 1'b0;
        cnt_2 <= 2'd0;
        CLK_10 <= 1'b0;
        cnt_10 <= 4'd0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'd0;
    end else begin
        // Increment counters and toggle output clocks as necessary
        // For 50MHz clock: Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // For 10MHz clock: Increment cnt_10 and toggle CLK_10 when cnt_10 reaches 4
        if (cnt_10 == 4'd4) begin
            cnt_10 <= 4'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // For 1MHz clock: Increment cnt_100 and toggle CLK_1 when cnt_100 reaches 49
        if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule