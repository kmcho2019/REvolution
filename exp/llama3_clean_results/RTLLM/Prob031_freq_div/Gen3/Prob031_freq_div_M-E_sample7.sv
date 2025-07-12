module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [0:0] cnt_50;  // Counter for generating 50MHz clock
reg [3:0] cnt_10;  // Counter for generating 10MHz clock
reg [6:0] cnt_1;   // Counter for generating 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_50  <= 1'b0;
        cnt_10  <= 4'b0000;
        cnt_1   <= 7'b0000000;
    end else begin
        // Generate 50MHz clock
        if (cnt_50 == 1'b1) begin
            CLK_50  <= ~CLK_50;
            cnt_50  <= 1'b0;
        end else begin
            cnt_50  <= cnt_50 + 1'b1;
        end

        // Generate 10MHz clock
        if (cnt_10 == 4'b1001) begin
            // Toggle CLK_10 and reset cnt_10
            CLK_10  <= ~CLK_10;
            cnt_10  <= 4'b0000;
        end else begin
            cnt_10  <= cnt_10 + 1'b1;
        end

        // Generate 1MHz clock
        if (cnt_1 == 7'b1100100) begin
            // Toggle CLK_1 and reset cnt_1
            CLK_1   <= ~CLK_1;
            cnt_1   <= 7'b0000000;
        end else begin
            cnt_1   <= cnt_1 + 1'b1;
        end
    end
end

endmodule