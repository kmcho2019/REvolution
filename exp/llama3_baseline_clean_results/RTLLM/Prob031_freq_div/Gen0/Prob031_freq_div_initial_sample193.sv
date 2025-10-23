module freq_div(
    input CLK_in,    // Input clock signal
    input RST,       // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2 = 2'b00;
reg [3:0] cnt_10 = 4'b0000;
reg [5:0] cnt_100 = 6'b000000;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b00;
        cnt_10 <= 4'b0000;
        cnt_100 <= 6'b000000;
    end
    else begin
        // For 50MHz clock generation
        cnt_2 <= cnt_2 + 1;
        if(cnt_2 == 2'b01) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b00;
        end

        // For 10MHz clock generation
        cnt_10 <= cnt_10 + 1;
        if(cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0000;
        end

        // For 1MHz clock generation
        cnt_100 <= cnt_100 + 1;
        if(cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end
    end
end

endmodule