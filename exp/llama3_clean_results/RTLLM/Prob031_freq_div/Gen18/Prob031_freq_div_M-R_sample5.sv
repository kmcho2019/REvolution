module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Counter for 10MHz clock
reg [2:0] counter_for_10mhz_clock;  
// Counter for 1MHz clock
reg [5:0] counter_for_1mhz_clock;  

// Reset logic
always @(posedge RST) begin
    counter_for_10mhz_clock <= 0;
    counter_for_1mhz_clock <= 0;
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
end

// Clock generation logic
always @(posedge CLK_in) begin
    // Toggle CLK_50 by inverting its current value
    CLK_50 <= ~CLK_50;
    
    // Generate CLK_10
    if(counter_for_10mhz_clock == 4) begin
        // Toggle CLK_10 by inverting its current value and reset counter
        CLK_10 <= ~CLK_10;
        counter_for_10mhz_clock <= 0;
    end else begin
        counter_for_10mhz_clock <= counter_for_10mhz_clock + 1;
    end
    
    // Generate CLK_1
    if(counter_for_1mhz_clock == 49) begin
        // Toggle CLK_1 by inverting its current value and reset counter
        CLK_1 <= ~CLK_1;
        counter_for_1mhz_clock <= 0;
    end else begin
        counter_for_1mhz_clock <= counter_for_1mhz_clock + 1;
    end
end

endmodule