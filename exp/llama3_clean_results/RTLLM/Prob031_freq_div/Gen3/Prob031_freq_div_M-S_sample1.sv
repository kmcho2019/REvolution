module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for CLK_50
reg [3:0] cnt_10; // Counter for CLK_10
reg [6:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counters and output clocks
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 every 2 clock cycles
        cnt_2 <= cnt_2 + 1;
        if(cnt_2 == 2'd1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 0;
        end
        
        // Toggle CLK_10 every 10 clock cycles
        cnt_10 <= cnt_10 + 1;
        if(cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        
        // Toggle CLK_1 every 100 clock cycles
        cnt_100 <= cnt_100 + 1;
        if(cnt_100 == 7'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule