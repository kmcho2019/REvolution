module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // 7-bit counter to generate clocks

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counter and output clocks
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment counter
        counter <= counter + 1;
        
        // Generate CLK_50
        // Use MSB of counter ( toggle every 64 clocks )
        CLK_50 <= counter[6];
        
        // Generate CLK_10
        // Toggle every 10 clocks (since 100MHz / 10 = 10MHz)
        if(counter == 9) begin
            CLK_10 <= ~CLK_10;
        end
        
        // Generate CLK_1
        // Toggle every 100 clocks (since 100MHz / 100 = 1MHz)
        if(counter == 99) begin
            CLK_1 <= ~CLK_1;
            counter <= 0;  // Reset counter for 1MHz clock
        end
    end
end

endmodule