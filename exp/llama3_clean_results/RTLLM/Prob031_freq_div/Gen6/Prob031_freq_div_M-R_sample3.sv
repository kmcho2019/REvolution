module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [0:0] cnt_2; // Counter for CLK_50
reg [3:0] cnt_10; // Counter for CLK_10
reg [6:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset the counters and output clocks
        cnt_2  <= 1'b0;
        cnt_10 <= 4'b0000;
        cnt_100 <= 7'b0000000;
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
    end else begin
        // Increment the counters
        cnt_2  <= cnt_2 + 1'b1;
        cnt_10 <= cnt_10 + 1'b1;
        cnt_100 <= cnt_100 + 1'b1;

        // Generate CLK_50
        if (cnt_2 == 1'b1) begin
            CLK_50  <= ~CLK_50;
            cnt_2  <= 1'b0;
        end

        // Generate CLK_10
        if (cnt_10 == 4'b1001) begin
            CLK_10  <= ~CLK_10;
            cnt_10 <= 4'b0000;
        end

        // Generate CLK_1
        if (cnt_100 == 7'b0110001) begin
            CLK_1   <= ~CLK_1;
            cnt_100 <= 7'b0000000;
        end
    end
end

endmodule