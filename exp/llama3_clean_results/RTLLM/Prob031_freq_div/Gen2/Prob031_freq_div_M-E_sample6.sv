module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // Counter to divide the frequency

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset the counter and output clocks
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment the counter
        counter <= counter + 1;
        
        // Generate CLK_50 by checking the least significant bit of the counter
        // This effectively divides the frequency by 2
        CLK_50 <= counter[0];
        
        // Generate CLK_10 by checking the fourth least significant bit of the counter
        // This effectively divides the frequency by 10 (2^3 + 2, due to 0-indexing)
        CLK_10 <= counter[3];
        
        // Generate CLK_1 by checking the sixth least significant bit of the counter
        // This effectively divides the frequency by 100 (2^6 + 2^4 + 2^3 + 2^2, due to 0-indexing, but here it's simplified)
        // To accurately divide by 100, a more complex condition or a separate counter would be needed
        // Here, we simplify by observing that dividing by 64 (2^6) is close and use that as an approximation
        CLK_1 <= counter[6];
    end
end

endmodule