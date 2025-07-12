module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for 10MHz clock
reg [5:0] cnt_100;  // Counter for 1MHz clock

// Reset logic
always @(posedge RST) begin
    cnt_10 <= 0;
    cnt_100 <= 0;
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
end

// Clock logic
always @(posedge CLK_in) begin
    if(RST) begin
        // This should not happen as reset is asynchronous, but for simulation purposes
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 by inverting its current value
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10
        if(cnt_10 < 4) begin
            cnt_10 <= cnt_10 + 1;
        end else begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end
        
        // Generate CLK_1
        if(cnt_100 < 49) begin
            cnt_100 <= cnt_100 + 1;
        end else begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule