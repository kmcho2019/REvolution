module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [5:0] cnt_100;  // Counter for CLK_1, also used for CLK_10 and CLK_50 derivation

// Generate CLK_50
always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
    end
end

// Generate CLK_10
always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_10 <= 0;
    end else if(cnt_100 == 9) begin
        CLK_10 <= ~CLK_10;
    end
end

// Generate CLK_1 and update counter
always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        if(cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule