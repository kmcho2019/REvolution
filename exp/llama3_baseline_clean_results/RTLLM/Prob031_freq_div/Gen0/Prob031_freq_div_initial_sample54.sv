module freq_div(
    input CLK_in, // Input clock signal
    input RST, // Reset signal
    output reg CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1 // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2; // counter for 50MHz clock
reg [2:0] cnt_10; // counter for 10MHz clock
reg [5:0] cnt_100; // counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        CLK_50 <= ~CLK_50; // toggle CLK_50 on every positive edge of CLK_in
        if (cnt_10 == 4'd9) begin // if cnt_10 reaches 9, toggle CLK_10 and reset cnt_10
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1; // increment cnt_10
        end
        if (cnt_100 == 6'd49) begin // if cnt_100 reaches 49, toggle CLK_1 and reset cnt_100
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1; // increment cnt_100
        end
    end
end

endmodule