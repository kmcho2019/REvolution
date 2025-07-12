module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] main_cnt;  // Main counter

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        main_cnt <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        main_cnt <= main_cnt + 1;
        
        // Generate CLK_50
        if(main_cnt[0] == 1'b1) begin
            CLK_50 <= ~CLK_50;
        end
        
        // Generate CLK_10
        if(main_cnt == 7'd9) begin
            CLK_10 <= ~CLK_10;
        end
        
        // Generate CLK_1
        if(main_cnt == 7'd99) begin
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule