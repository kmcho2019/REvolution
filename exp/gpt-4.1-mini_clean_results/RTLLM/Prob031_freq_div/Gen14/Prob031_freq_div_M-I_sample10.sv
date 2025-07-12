module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100;   // Single counter for divide by 10 and 100 clocks

    // Divide by 2 clock generation (50 MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Single counter managing both 10 MHz and 1 MHz clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (cnt_100 == 7'd99) begin
                cnt_100 <= 7'd0;
                CLK_1   <= ~CLK_1;          // Toggle every 100 cycles -> 1 MHz
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end

            // Toggle 10 MHz clock (divide by 10, toggle every 5 cycles)
            if (cnt_100[3:0] == 4'd4)        // At count 4, 14, 24,... toggle CLK_10
                CLK_10 <= ~CLK_10;
        end
    end

endmodule