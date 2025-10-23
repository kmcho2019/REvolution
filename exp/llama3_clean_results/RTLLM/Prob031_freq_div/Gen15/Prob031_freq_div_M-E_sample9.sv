module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // Counter to divide the input clock frequency

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset the counter and output clocks
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Increment the counter
        if(counter == 99) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate output clocks based on counter value
        if(counter == 0 || counter == 50) begin
            CLK_50 <= ~CLK_50;  // Toggle CLK_50 every 50 counter values
        end
        if(counter == 0 || counter == 10 || counter == 20 || counter == 30 || counter == 40 || counter == 50 || counter == 60 || counter == 70 || counter == 80 || counter == 90) begin
            CLK_10 <= ~CLK_10;  // Toggle CLK_10 every 10 counter values
        end
        if(counter == 0) begin
            CLK_1 <= ~CLK_1;  // Toggle CLK_1 every 100 counter values
        end
    end
end

endmodule