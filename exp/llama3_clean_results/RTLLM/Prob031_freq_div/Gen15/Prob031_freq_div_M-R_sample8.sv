module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for 10MHz clock
reg [5:0] cnt_100;  // Counter for 1MHz clock

// Generate CLK_50
always @(posedge CLK_in) begin
    if(RST) begin
        CLK_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
    end
end

// Generate CLK_10
always @(posedge CLK_in) begin
    if(RST) begin
        CLK_10 <= 0;
        cnt_10 <= 0;
    end else if(cnt_10 == 4) begin
        CLK_10 <= ~CLK_10;
        cnt_10 <= 0;
    end else begin
        cnt_10 <= cnt_10 + 1;
    end
end

// Generate CLK_1
always @(posedge CLK_in) begin
    if(RST) begin
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else if(cnt_100 == 49) begin
        CLK_1 <= ~CLK_1;
        cnt_100 <= 0;
    end else begin
        cnt_100 <= cnt_100 + 1;
    end
end

endmodule