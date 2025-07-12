module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // Counter to generate all three output clock frequencies

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        counter <= counter + 1;
        
        // Generate CLK_50
        if(counter[0] == 1'b0) begin
            CLK_50 <= ~CLK_50;
        end
        
        // Generate CLK_10
        if(counter[3:0] == 4'b1000) begin
            counter[3:0] <= 0;
            CLK_10 <= ~CLK_10;
        end
        
        // Generate CLK_1
        if(counter[5:0] == 6'b110001) begin
            counter[5:0] <= 0;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule