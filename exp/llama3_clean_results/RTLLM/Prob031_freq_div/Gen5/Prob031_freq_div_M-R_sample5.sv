module freq_div (
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt; // Counter

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset the counter and output clocks
        cnt  <= 7'b0000000;
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
    end else begin
        // Increment the counter
        cnt  <= cnt + 1'b1;

        // Generate CLK_50
        if (cnt == 7'b0000001) begin
            CLK_50  <= ~CLK_50;
        end

        // Generate CLK_10
        if (cnt == 7'b0000101) begin
            CLK_10  <= ~CLK_10;
        end

        // Generate CLK_1
        if (cnt == 7'b01100011) begin
            CLK_1   <= ~CLK_1;
        end

        // Reset the counter
        if (cnt == 7'b10000000) begin
            cnt  <= 7'b0000000;
        end
    end
end

endmodule