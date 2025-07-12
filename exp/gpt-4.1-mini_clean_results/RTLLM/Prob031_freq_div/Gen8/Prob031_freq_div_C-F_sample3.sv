module freq_div (
    input  wire CLK_in,  // 100 MHz input clock
    input  wire RST,     // Synchronous active-high reset
    output reg  CLK_50,  // 50 MHz output clock (divide by 2)
    output reg  CLK_10,  // 10 MHz output clock (divide by 10)
    output reg  CLK_1    // 1 MHz output clock (divide by 100)
);

    // Counter for 10 MHz clock division (divide by 10)
    // Counts from 0 to 4, toggles CLK_10 at count 4
    reg [2:0] cnt_10;

    // Counter for 1 MHz clock division (divide by 100)
    // Counts from 0 to 49, toggles CLK_1 at count 49
    reg [5:0] cnt_100;

    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all outputs and counters synchronously
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // Toggle CLK_50 every CLK_in rising edge => divide by 2
            CLK_50 <= ~CLK_50;

            // 10 MHz clock divider logic
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;   // Toggle output clock
                cnt_10 <= 3'd0;     // Reset counter
            end else begin
                cnt_10 <= cnt_10 + 3'd1; // Increment counter
            end

            // 1 MHz clock divider logic
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;    // Toggle output clock
                cnt_100 <= 6'd0;   // Reset counter
            end else begin
                cnt_100 <= cnt_100 + 6'd1; // Increment counter
            end
        end
    end

endmodule