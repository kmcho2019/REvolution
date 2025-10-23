module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] counter_50;  
reg [3:0] counter_10;  
reg [6:0] counter_100;  

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        counter_50 <= 0;
        counter_10 <= 0;
        counter_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        counter_50 <= counter_50 + 1;
        counter_10 <= counter_10 + 1;
        counter_100 <= counter_100 + 1;
        
        if (counter_50 == 1) begin
            CLK_50 <= ~CLK_50;
            counter_50 <= 0;
        end
        
        if (counter_10 == 9) begin
            CLK_10 <= ~CLK_10;
            counter_10 <= 0;
        end
        
        if (counter_100 == 99) begin
            CLK_1 <= ~CLK_1;
            counter_100 <= 0;
        end
    end
end

endmodule