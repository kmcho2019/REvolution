module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [7:0] counter;  // Counter to track clock cycles

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
        
        // Generate CLK_50: Toggle every 2 clock cycles
        if(counter == 1) begin
            CLK_50 <= ~CLK_50;
        end
        
        // Generate CLK_10: Toggle every 10 clock cycles
        if(counter == 9) begin
            CLK_10 <= ~CLK_10;
            counter <= 0;  // Reset counter for CLK_10
        end
        
        // Generate CLK_1: Toggle every 100 clock cycles
        if(counter == 99) begin
            CLK_1 <= ~CLK_1;
            counter <= 0;  // Reset counter for CLK_1
        end
    end
end

endmodule