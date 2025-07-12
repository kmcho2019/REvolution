module freq_div (
    input  wire  CLK_in,  // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for generating 50MHz clock
reg [3:0] cnt_10; // Counter for generating 10MHz clock
reg [5:0] cnt_100; // Counter for generating 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        cnt_2  <= 2'b00;
        cnt_10 <= 4'b0000;
        cnt_100 <= 6'b000000;
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if (cnt_10 == 4'b1000) begin
            // Toggle CLK_10 and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0000;
        end else begin
            // Increment counter
            cnt_10 <= cnt_10 + 1'b1;
        end

        // Generate CLK_1
        if (cnt_100 == 6'b110001) begin
            // Toggle CLK_1 and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            // Increment counter
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule