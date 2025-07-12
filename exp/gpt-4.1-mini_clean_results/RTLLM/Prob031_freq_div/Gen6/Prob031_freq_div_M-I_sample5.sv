module freq_div (
    input  wire CLK_in,  // 100 MHz input clock
    input  wire RST,     // synchronous active-high reset
    output reg  CLK_50,  // 50 MHz output clock (divide by 2)
    output reg  CLK_10,  // 10 MHz output clock (divide by 10)
    output reg  CLK_1    // 1 MHz output clock (divide by 100)
);

    reg [5:0] cnt;  // single counter from 0 to 49 to cover both 10 MHz and 1 MHz divides

    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt <= 6'd0;
        end else begin
            // 50 MHz toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Counter increment and wrap
            if (cnt == 6'd49) begin
                cnt <= 6'd0;
            end else begin
                cnt <= cnt + 6'd1;
            end

            // Toggle 10 MHz clock at count 4 and 49, to maintain 10 MHz frequency
            // Since 10 MHz period = 10 cycles, toggle every 5 cycles (counts 4 and 49)
            if (cnt == 6'd4 || cnt == 6'd49) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle 1 MHz clock at count 49 (every 50 cycles), divide by 100 total
            if (cnt == 6'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule