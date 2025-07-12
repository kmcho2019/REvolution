module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // Single counter that increments on every clock cycle

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
        
        // Generate output clocks using bitwise operations
        CLK_50 <= counter[0];  // LSB of counter
        CLK_10 <= counter[3];  // Fourth LSB of counter
        CLK_1 <= counter[6];  // Seventh LSB of counter
    end
end

endmodule