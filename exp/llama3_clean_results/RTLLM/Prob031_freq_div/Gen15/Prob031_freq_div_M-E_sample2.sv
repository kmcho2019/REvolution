module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Counter for clock division

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counter and output clocks
        cnt <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment counter
        if(cnt == 99) begin
            cnt <= 0;
            // Toggle CLK_1
            CLK_1 <= ~CLK_1;
            // Toggle CLK_50
            CLK_50 <= ~CLK_50;
        end else begin
            cnt <= cnt + 1;
            // Toggle CLK_50
            if(cnt == 49) begin
                CLK_50 <= ~CLK_50;
            end
            // Toggle CLK_10
            if(cnt == 9) begin
                CLK_10 <= ~CLK_10;
            end
        end
    end
end

endmodule