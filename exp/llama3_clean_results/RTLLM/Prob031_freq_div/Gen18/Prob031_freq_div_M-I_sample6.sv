module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for 10MHz clock
reg [5:0] cnt_100;  // Counter for 1MHz clock
reg clk_en_10;  // Clock enable for cnt_10
reg clk_en_100;  // Clock enable for cnt_100

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and output clocks
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        clk_en_10 <= 0;
        clk_en_100 <= 0;
    end else begin
        // Toggle CLK_50 by inverting its current value
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10
        if(cnt_10 == 4) begin
            // Toggle CLK_10 by inverting its current value and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
            clk_en_10 <= 0;
        end else begin
            if(clk_en_10) begin
                cnt_10 <= cnt_10 + 1;
            end
            if(cnt_10 == 0) begin
                clk_en_10 <= 1;
            end
        end
        
        // Generate CLK_1
        if(cnt_100 == 49) begin
            // Toggle CLK_1 by inverting its current value and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
            clk_en_100 <= 0;
        end else begin
            if(clk_en_100) begin
                cnt_100 <= cnt_100 + 1;
            end
            if(cnt_100 == 0) begin
                clk_en_100 <= 1;
            end
        end
    end
end

// Clock gating
always @(posedge CLK_in) begin
    if(clk_en_10) begin
        // Enable clock for cnt_10
    end else begin
        // Disable clock for cnt_10
    end
    if(clk_en_100) begin
        // Enable clock for cnt_100
    end else begin
        // Disable clock for cnt_100
    end
end

endmodule