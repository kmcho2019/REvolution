module freq_div (
    input  wire CLK_in,  // 100 MHz input clock
    input  wire RST,     // Synchronous active-high reset
    output reg  CLK_50,  // 50 MHz output clock (divide by 2)
    output reg  CLK_10,  // 10 MHz output clock (divide by 10)
    output reg  CLK_1    // 1 MHz output clock (divide by 100)
);

    // Counter for 10 MHz clock division (divide by 10)
    // Counts from 0 to 4, toggles CLK_10 on count 4 to achieve divide by 10.
    reg [2:0] cnt_10;

    // Counter for 1 MHz clock division (divide by 100)
    // Counts from 0 to 49, toggles CLK_1 on count 49 to achieve divide by 100.
    reg [5:0] cnt_100;

    // Generate 50 MHz clock by toggling CLK_50 every CLK_in positive edge (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Generate 10 MHz clock: divide by 10
    // cnt_10 counts from 0 to 4, toggle CLK_10 at terminal count then reset counter.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
        end
    end

    // Generate 1 MHz clock: divide by 100
    // cnt_100 counts from 0 to 49, toggle CLK_1 at terminal count then reset counter.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule