module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1

// Reset logic
assign CLK_50 = (RST) ? 0 : ~CLK_50;
assign CLK_10 = (RST) ? 0 : (cnt_10 == 4) ? ~CLK_10 : CLK_10;
assign CLK_1 = (RST) ? 0 : (cnt_100 == 49) ? ~CLK_1 : CLK_1;

// Generate all clocks
always @(posedge CLK_in) begin
    if(RST) begin
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        if(cnt_10 == 4) begin
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        if(cnt_100 == 49) begin
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

always @(posedge RST) begin
    cnt_10 <= 0;
    cnt_100 <= 0;
end

endmodule