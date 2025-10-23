module freq_div (
    input           CLK_in,    // Input clock signal
    input           RST,      // Reset signal
    output reg      CLK_50,   // Output clock signal with a frequency of CLK_in divided by 2
    output reg      CLK_10,   // Output clock signal with a frequency of CLK_in divided by 10
    output reg      CLK_1     // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 4'd0;
        cnt_100 <= 6'd0;
    end else begin
        // Generate 50MHz clock signal
        CLK_50 <= ~CLK_50;

        // Generate 10MHz clock signal
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4'd9) begin
            cnt_10 <= 4'd0;
            CLK_10 <= ~CLK_10;
        end

        // Generate 1MHz clock signal
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule