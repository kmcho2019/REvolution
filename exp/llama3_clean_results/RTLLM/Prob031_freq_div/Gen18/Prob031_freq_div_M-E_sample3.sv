module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // 7-bit counter

always @(posedge CLK_in) begin
    if(RST) begin
        // Reset counter and output clocks
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment counter
        counter <= counter + 1;
        
        // Toggle CLK_50 on every other clock cycle
        CLK_50 <= ~CLK_50;
        
        // Toggle CLK_10 when counter value is 9 or 99
        if(counter == 9 || counter == 99) begin
            CLK_10 <= ~CLK_10;
        end
        
        // Toggle CLK_1 when counter value is 99
        if(counter == 99) begin
            CLK_1 <= ~CLK_1;
        end
        
        // Reset counter when it reaches 100
        if(counter == 100) begin
            counter <= 0;
        end
    end
end

endmodule