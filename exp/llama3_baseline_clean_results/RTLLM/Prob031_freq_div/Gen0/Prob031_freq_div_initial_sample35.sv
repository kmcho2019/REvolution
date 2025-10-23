module freq_div(
    input  CLK_in,  // Input clock signal
    input  RST,     // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Counter for 10MHz clock generation
reg [2:0] cnt_10;
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b000;
    end
    else if (cnt_10 == 4'b1000) begin
        CLK_10 <= ~CLK_10;
        cnt_10 <= 3'b000;
    end
    else begin
        cnt_10 <= cnt_10 + 1'b1;
    end
end

// Counter for 1MHz clock generation
reg [5:0] cnt_100;
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end
    else if (cnt_100 == 6'b110001) begin
        CLK_1 <= ~CLK_1;
        cnt_100 <= 6'b000000;
    end
    else begin
        cnt_100 <= cnt_100 + 1'b1;
    end
end

// 50MHz clock generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
    end
    else begin
        CLK_50 <= ~CLK_50;
    end
end

endmodule