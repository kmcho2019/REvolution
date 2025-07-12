module freq_div(
    input  wire CLK_in,  // Input clock signal
    input  wire RST,     // Reset signal
    output reg  CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg  CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg  CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for CLK_50
reg [2:0] cnt_10;  // Counter for CLK_10
reg [6:0] cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all output clocks and counters
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 3'b0;
        cnt_100 <= 7'b0;
    end else begin
        // Generate CLK_50
        cnt_2 <= cnt_2 + 1'b1;
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end

        // Generate CLK_10
        cnt_10 <= cnt_10 + 1'b1;
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end

        // Generate CLK_1
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 7'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end
    end
end

endmodule