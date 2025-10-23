module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1
reg clk_en_10;  // Clock enable for cnt_10
reg clk_en_100;  // Clock enable for cnt_100

// Generate output clocks
always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counters and output clocks
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        clk_en_10 <= 0;
        clk_en_100 <= 0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Update counters and generate output clocks
        if(cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
            clk_en_10 <= 0;
        end else if (cnt_10 < 4) begin
            cnt_10 <= cnt_10 + 1;
            clk_en_10 <= 1;
        end

        if(cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
            clk_en_100 <= 0;
        end else if (cnt_100 < 49) begin
            cnt_100 <= cnt_100 + 1;
            clk_en_100 <= 1;
        end
    end
end

// Clock gating
always @(posedge CLK_in) begin
    if(clk_en_10) begin
        // Update cnt_10
        cnt_10 <= cnt_10 + 1;
    end
    if(clk_en_100) begin
        // Update cnt_100
        cnt_100 <= cnt_100 + 1;
    end
end

endmodule