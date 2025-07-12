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
        // Toggle CLK_50 by inverting its current value
        CLK_50 <= ~CLK_50;
        
        // Increment counter
        counter <= counter + 1;
        
        // Generate CLK_10
        if(counter == 9) begin
            // Toggle CLK_10 by inverting its current value and reset counter
            CLK_10 <= ~CLK_10;
            counter <= 0;
        end
        
        // Generate CLK_1
        if(counter == 99) begin
            // Toggle CLK_1 by inverting its current value and reset counter
            CLK_1 <= ~CLK_1;
            counter <= 0;
        end
    end
end

endmodule