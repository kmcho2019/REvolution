module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100; // Single counter counting from 0 to 99

    // Divide by 2 clock generation (50 MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Single counter for divide by 10 and divide by 100 clocks
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == 7'd99) begin
            cnt_100 <= 7'd0;
            // Toggle CLK_10 every 5 cycles -> toggle at cnt_10 == 4 (every 10 cycles total)
            // But since counter counts 0 to 99, toggle CLK_10 every 5 counts (at 4,14,24,...)
            // To emulate this with one counter, toggle CLK_10 when (cnt_100 % 10 == 4)
            // Similarly toggle CLK_1 at 49
            // Here toggles happen at counter boundaries:
            // To simplify, perform toggles at correct counts in combinational style:

            // Toggles happen here in synchronous always for counts 4 and 49; since we only toggle at count 99 reset,
            // We'll do toggles inside counter increment logic by checking count below.
            // However, since we reset at 99, we toggle here also.

            // Actually to meet original specs exactly, toggles must happen at 4 and 49
            // So we move toggles to below as combinational checks.
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

    // Toggle CLK_10 at cnt_100 == 4, 14, 24, ..., 94
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_10 <= 1'b0;
        else if (cnt_100 == 7'd4 || cnt_100 == 7'd14 || cnt_100 == 7'd24 || cnt_100 == 7'd34 || cnt_100 == 7'd44 ||
                 cnt_100 == 7'd54 || cnt_100 == 7'd64 || cnt_100 == 7'd74 || cnt_100 == 7'd84 || cnt_100 == 7'd94)
            CLK_10 <= ~CLK_10;
    end

    // Toggle CLK_1 at cnt_100 == 49
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_1 <= 1'b0;
        else if (cnt_100 == 7'd49)
            CLK_1 <= ~CLK_1;
    end

endmodule